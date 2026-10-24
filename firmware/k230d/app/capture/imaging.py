# 图像小工具（票 06 草稿）：纯 Python，作用在“灰度二维列表”上，只用于主机侧 mock 与逻辑验证。
# 图像约定：image 是 list of rows，每行是 list of int（0-255 灰度），所有行等长。
# 板上不会用这些循环处理 640x480 的帧：
#   # 板侧占位（未在 CanMV 板上核对，API 名称待厂商例程确认）：
#   #   运动检测 -> 用板上 image 库的差分 / blob 查找，不在 Python 里逐像素循环
#   #   清晰度   -> 用板上 image 库的统计或拉普拉斯滤波，再取方差
#   #   裁图     -> 用板上 image 库的 copy / crop，并在复制后释放采集缓冲
# 这里的函数只保证签名和语义，供 CaptureManager 在主机上走通流程。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。


def image_size(image):
    """返回 (宽, 高)。空图像或行不等长抛 ValueError。"""
    if not isinstance(image, list) or len(image) == 0:
        raise ValueError("image 必须是非空的行列表")
    width = len(image[0])
    if width == 0:
        raise ValueError("image 的行不能为空")
    for row in image:
        if len(row) != width:
            raise ValueError("image 各行长度不一致")
    return width, len(image)


def new_image(width, height, fill=0):
    """造一张纯色假图，测试用。"""
    if width <= 0 or height <= 0:
        raise ValueError("图像宽高必须为正")
    rows = []
    for _ in range(height):
        rows.append([fill] * width)
    return rows


def crop_roi(image, roi):
    """按 roi=(x, y, w, h) 复制出子图（复制，不是视图）。越界部分被裁掉；裁完为空抛 ValueError。"""
    width, height = image_size(image)
    x, y, w, h = roi
    x0 = max(0, x)
    y0 = max(0, y)
    x1 = min(width, x + w)
    y1 = min(height, y + h)
    if x1 <= x0 or y1 <= y0:
        raise ValueError("roi 与图像没有交集: %r" % (roi,))
    rows = []
    for yy in range(y0, y1):
        rows.append(list(image[yy][x0:x1]))
    return rows


def clamp_roi(roi, max_w, max_h):
    """roi 超过 (max_w, max_h) 时按中心裁小，保持中心不变（对应 roi_size_max 配置）。"""
    x, y, w, h = roi
    if w > max_w:
        x = x + (w - max_w) // 2
        w = max_w
    if h > max_h:
        y = y + (h - max_h) // 2
        h = max_h
    return (x, y, w, h)


def laplacian_variance(image):
    """4 邻域拉普拉斯响应的方差，越大越清晰（ADR 0002 用它在 3 帧里排序）。图像小于 3x3 返回 0.0。"""
    width, height = image_size(image)
    if width < 3 or height < 3:
        return 0.0
    values = []
    for y in range(1, height - 1):
        for x in range(1, width - 1):
            v = (image[y - 1][x] + image[y + 1][x] + image[y][x - 1] + image[y][x + 1]
                 - 4 * image[y][x])
            values.append(v)
    mean = sum(values) / len(values)
    total = 0.0
    for v in values:
        total += (v - mean) * (v - mean)
    return total / len(values)


def sharpest_index(images):
    """返回清晰度最高的下标；并列时取最早的一张。空列表抛 ValueError。"""
    if len(images) == 0:
        raise ValueError("没有可比较的图像")
    best = 0
    best_score = laplacian_variance(images[0])
    for i in range(1, len(images)):
        score = laplacian_variance(images[i])
        if score > best_score:
            best = i
            best_score = score
    return best


def foreground_roi(prev_image, cur_image, motion_threshold):
    """两帧逐像素差大于 motion_threshold 的像素的外接框 (x, y, w, h)；没有变化返回 None。

    motion_threshold 来自 capture_config.json（初值 25），不在代码里硬编码。
    """
    pw, ph = image_size(prev_image)
    cw, ch = image_size(cur_image)
    if (pw, ph) != (cw, ch):
        raise ValueError("前后两帧尺寸不一致")
    min_x = None
    max_x = None
    min_y = None
    max_y = None
    for y in range(ch):
        prow = prev_image[y]
        crow = cur_image[y]
        for x in range(cw):
            diff = crow[x] - prow[x]
            if diff < 0:
                diff = -diff
            if diff > motion_threshold:
                if min_x is None:
                    min_x = max_x = x
                    min_y = max_y = y
                else:
                    if x < min_x:
                        min_x = x
                    if x > max_x:
                        max_x = x
                    if y < min_y:
                        min_y = y
                    if y > max_y:
                        max_y = y
    if min_x is None:
        return None
    return (min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)
