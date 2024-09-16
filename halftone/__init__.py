import skimage
from colormath.color_conversions import convert_color
from colormath.color_objects import sRGBColor, LCHuvColor
from matplotlib import pyplot as plt

if __name__ == '__main__':


    colors = {
        "bla": sRGBColor(0, 0, 0, is_upscaled=True),
        "g25": sRGBColor(63, 63, 63, is_upscaled=True),
        "g50": sRGBColor(127, 127, 127, is_upscaled=True),
        "g75": sRGBColor(195, 195, 195, is_upscaled=True),
        "whi": sRGBColor(255, 255, 255, is_upscaled=True),
        "red": sRGBColor(255, 0, 0, is_upscaled=True),
        "yel": sRGBColor(255, 255, 0, is_upscaled=True),
        "gre": sRGBColor(0, 255, 0, is_upscaled=True),
        "cya": sRGBColor(0, 255, 255, is_upscaled=True),
        "blu": sRGBColor(0, 0, 255, is_upscaled=True),
        "mag": sRGBColor(255, 0, 255, is_upscaled=True),
    }

    for name, color in colors.items():
        result = convert_color(color, LCHuvColor)
        print(f"{name}: L = {int(result.lch_l)}, c = {int(result.lch_c)}, h = {int(result.lch_h) - 12}°")

    image = skimage.io.imread('../resources/basement.png')
    plt.imshow(image)