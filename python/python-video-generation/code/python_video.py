import moviepy.editor as mpy
from moviepy.video.tools.segmenting import findObjects

STARS_PATH = "./assets/stars-5.png"
SB_LOGO_PATH = "./assets/logo_sb.png"
WHITE = (255, 255, 255)
VERTICAL_SPACE=30
HORIZONTAL_SPACE=100
SCREEN_SIZE = (640, 480)
CLOCKWISE_ANGLE = -90

def rotate(stars):
    return [
        star.rotate(lambda t: t * CLOCKWISE_ANGLE, expand=False)
        .fx(mpy.vfx.mask_color)
        .set_position(((i + 1) * HORIZONTAL_SPACE, sb_logo.size[1] + txt_clip.size[1] + VERTICAL_SPACE * 2))
        for i, star in enumerate(stars)
    ]


if __name__ == "__main__":
    sb_logo = mpy.ImageClip(SB_LOGO_PATH).set_position(("center", VERTICAL_SPACE * 1.5)).resize(width=200)

    txt_clip = mpy.TextClip(
        "Let's build together",
        font="Charter-bold",
        color="RoyalBlue4",
        kerning=4,
        fontsize=30,
        stroke_color="RoyalBlue4",
        stroke_width=0.8,
    ).set_position(("center", sb_logo.size[1] + VERTICAL_SPACE))

    stars_clip = mpy.CompositeVideoClip(
        [mpy.ImageClip(STARS_PATH).set_position("center")], size=SCREEN_SIZE
    )
    stars = findObjects(stars_clip)

    txt_watermark = mpy.TextClip(
        "This video was generated with Python",
        color="#ff8c82",
        kerning=4,
        fontsize=22,
        stroke_color="#ff8c82",
        stroke_width=0.4,
    ).set_position(("center", sb_logo.size[1] + txt_clip.size[1] + VERTICAL_SPACE * 6))

    final_clip = (
        mpy.CompositeVideoClip([sb_logo, txt_clip, txt_watermark] + rotate(stars), size=SCREEN_SIZE)
        .on_color(color=WHITE, col_opacity=1)
        .set_duration(10)
    )
    final_clip.write_videofile("video_with_python.mp4", fps=10)
    # final_clip.write_gif("video_with_python.gif", fps=10)
