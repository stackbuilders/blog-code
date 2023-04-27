---
title: Video Generation with Python
published: 2019-07-17
tags: Python, video, multimedia, custom media
language: python
author-name: Sebastian Arias
twitter-profile: sebasarias95
github-profile: larox
description: Python is a language that can be use for everything, generating multimedia content like a video is a good and fun way to get started in Python.
last-updated: 2022-04-26
last-updated-by: Andres Perez
---


When you hear about Python, you might have in mind the powerful interpreted
programming language used for data science, artificial intelligence and for
web apps with [Flask][flask] or [Django][django]. However, Python is not only
capable of achieving all of this, but here in Stack Builders we’ve also used
it to create and render a fully customized video with animations, text and images using Python’s [MoviePy][moviepy], [SciPy][scipy] and [ImageMagick][imagemagick] libraries.

## The Challenge

Creating a customized video might sound easy, especially if tools for video
editing are an option. Creating one or maybe a couple of them might even
sound fun, but if you need to generate hundreds or even thousands of
customized videos daily, this does not sound like a good idea. Imagine
Facebook manually creating millions of videos for friendship anniversaries,
birthdays and marketing campaigns for all their users. That would require an
extreme amount of time to do, create delays in the delivery of the videos,
and take away from an ideal user experience.

Producing a video programmatically might not be a task developers come across
daily. Having a firm understanding of what the final video should look like
is vital for accomplishing this task.

## Facing the challenge

Here is where software development comes in handy and helps automate tasks to
make our lives easier once again. Having a toolbelt filled with tools like
Python gives us the upper hand in this challenge. This open source
tutorial/contribution will explain how to work with multiple video segments
using `MoviePy` tools together.

## What is MoviePy?

You might have heard of [FFMPEG][ffmpeg] or [ImageMagick][imagemagick] for
image and video edition in a programmatically way. [MoviePy][moviepy] is a
Python module for video editing (Python wrapper for FFMPEG and ImageMagick). It provides
functions for cutting, concatenations, title insertions, video compositing,
video processing, and the creation of custom effects. It can read and write
common video and audio formats and be run on any platform with Python 2.7 or
3+.

## What is ImageMagick?

[ImageMagick][imagemagick] is a open-source software suite, used for editing and manipulating digital images. It includes a command-line interface for executing complex image processing tasks, as well as APIs for integrating its features into software applications. `MoviePy` [TextClip][txt-clip] requires ImageMagick. 

## What is SciPy?

[SciPy][scipy] is a library used for scientific computing and technical computing. SciPy contains modules for image processing. MoviePy video tools plugins like [`Segmenting`][mpy-segmenting] benfits from this to locate objects and separate them.

## What do we need?

For this tutorial, is required ImageMagick installed and Python 3 with pipenv to manage its dependencies. All the
modules can be installed from PyPI (Python Package Index) using `pip`. For
further instructions check this file [here][readme].

## Getting Started

This sample code will help to understand some basic concepts about Python, MoviePy
and image processing libraries.

### Importing the libraries

```python
import moviepy.editor as mpy
from moviepy.video.tools.segmenting import findObjects
```
In this piece of code we are telling Python to add the libraries that are
going to be used in this tutorial to keep it simple, we are adding all of the
MoviePy tools inside its *editor* module and renaming it to mpy to keep it
short.

In the next line, the MoviePy plugin `find_objects` is imported to locate and separate objects in a clip. We are adding it to locate five stars in an png file for later animate them in the final clip.

### Creating constants
First of all, we are going to create some
constants to keep the code easy to understand. The first one is `WHITE`. It is
going to be the background color. MoviePy uses the traditional
RGB scale (0 - 255).

The second one is `SCREEN_SIZE`, we will be using a standard of `640x480`.

The rest of them `VERTICAL_SPACE` and `HORiZONTAL_SPACE` are used for adding homogenous horizontal and vertical space across elements in the video.

```python
WHITE = (255, 255, 255)
SCREEN_SIZE = (640, 480)
VERTICAL_SPACE=30
HORIZONTAL_SPACE=100
```


### Adding an Image File

It's time to use Moviepy! We can add some images to the video to make
it more attractive to the viewers. For this we will be using the following code:

``` Python
SB_LOGO_PATH = "./static/StackBuildersLogo.jpg"

sb_logo = mpy.ImageClip(SB_LOGO_PATH).\
    set_position(('center', 0)).\
    resize(width=200)
```

The `mpy.ImageClip` function receives as a parameter the image to render. In
this case the image path is set in the constant `SB_LOGO_PATH`. Using
`ImageClip` attributes, it's possible to position the image using x, y
coordinates. In this case, it's possible to mix keywords like `center`,
`bottom` and `top` with specific coordinates.

Finally, the `resize` attribute reduces the size of the image keeping its
ratio aspect using the key arguments `width` or `height` like in the snippet.
It is possible to set a custom size explicitly using a tuple with the new
dimensions `(width, height)`.


### Writing text

Now that we have the image in place, using `TextClip` we are able to create an
instance of a video with centered text below the logo image.

```python
    txt_clip = mpy.TextClip(
        "Let's build together",
        font="Charter-bold",
        color="RoyalBlue4",
        kerning=4,
        fontsize=30,
    ).\
    set_position(("center", sb_logo.size[1] + VERTICAL_SPACE]))
```

The variable `txt_clip` is created for use in video composition later, it is a [`TextClip`][txt-clip] instance that receives the text to display as first parameter. The other parameters are used to style
the text. Setting `font`, `color`, `kerning` and `fontsize` is enough.

Finally, it sets the position it will have when included in compositions, with the function `set_position`, it receives a tuple that contains the horizontal and vertical values. The positions are set here
directly to use the `sb_logo` attribute `size` that provides a tuple of the
clip dimensions `(width, height)`. This helps to calculate in an easier way
the `y-position` of each clip. In this case the text is horizontally centered using `center` key and have a calculated vertical space value based on the logo clip vertical size plus a constant to put some extra space.



### Adding animation fx

With the text and image ready there is just one thing left to implement: Rotating stars (just because this video deserves 5 stars).

MoviePy is capable of locate and separate objects like letters or shapes in a clip. However, in this case we are going to use an image with stars to apply a rotate effect in each of them.

``` Python
STARS_PATH = "./static/stars-5.png"

stars_clip = mpy.CompositeVideoClip(
    [mpy.ImageClip(STARS_PATH).set_position("center")], size=SCREEN_SIZE
stars = findObjects(stars_clip)
)
```

As for the image file, we first start creating an `ImageClip` with the image containing the stars by passing the path set in the constant 'STARS_PATH'.

Add it to a composite video by using `mpy.CompositeVideoClip` we can generate a `VideoClip` made up of other
clips displayed together. For this sample the first parameter is a list with a single element and the second argument is the screen size `640x680`.

Next, assign it to the `stars_clip` var to pass it as argument in the function `findObjects` to get each star separated in a list.

``` Python
CLOCKWISE_ANGLE = -90

def rotate(stars):
    return [
        star.rotate(lambda t: t * CLOCKWISE_ANGLE, expand=False)
        .fx(mpy.vfx.mask_color)
        .set_position(((i + 1) * HORIZONTAL_SPACE, sb_logo.size[1] + txt_clip.size[1] + VERTICAL_SPACE * 2))
        for i, star in enumerate(stars)
    ]
```
This is where the fun begins! As we said before, this video deserves 5 stars,
and since configure them to rotate one-by-one could be very repetitive, we are going to create a function that receives a list of stars and use a for loop in a list comprehension to return the list of stars inside clips (Like we
did with the `txt_clip` and `sb_logo` clips) and rotating them in clockwise direction. 

The `rotate` function receives as a first parameter the stars `ImageClip`s to rotate. It uses the video effects function `rotate` with a lambda function as first parameter to rotate the star on its own axis in clockwise direction for each frame `t` by multiplilying the time in the video by (-90) degrees. Regarding the other parameter `expand` is set to False to maintain the same size of the clip.

If the angle of rotation is not one of 90, 180, -90, -180 (degrees) there will be black borders. We can make them transparent with `fx(mpy.vfx.mask_color)` that sets a transparent mask color by default.

Finally, the position of each star is calculated so that they are centered below the image/text and horizontally separated equally between each other. 


### Generating The Video Clip

```Python
final_clip = (
    mpy.CompositeVideoClip([sb_logo, txt_clip] + rotate(stars), size=SCREEN_SIZE)
    .on_color(color=WHITE, col_opacity=1)
    .set_duration(10)
)
```

This piece of code is using `mpy.CompositeVideoClip` to compse a video clip with the clips already created `sb_logo` and `txt_clip`. Additionally it concatenates to that all the stars rotating provided by our `rotate` method.

The second parameter in `CompositeVideoClip` is the size of the final clip in this case `(640x480)`.

The `on_color` attribute helps to set the background color of the `VideoClip`
to `color=WHITE`. The `on_color` attribute has some extra parameters to
change `size`, `position` and `color opacity`, but for now we don't need
them.

And last but not least, the video duration is set to 10 seconds using
`set_duration` attribute.

```Python
final_clip.write_videofile("video_with_python.mp4", fps=10)
```

Finally, the `write_videofile` attribute writes in the disk the `VideoClip`
result of the `CompositeVideoClip` stored in memory. Its first parameter is
the `video file name`, then we define the `fps` rate. The `write_videofile`
has multiple parameters but we just need to set these two for now.

Now if we run the code using `python python_video.py`, we will
have a 10 seconds video like this:

<div style="text-align:center">
<img src="https://github.com/stackbuilders/tutorials/raw/tutorials/tutorials/python/python-video-generation/images/video.gif" width=500 /> </br>
**Figure 1** - Video generated by our code
</div>

This might seem simple, but its our first video generated by code! If you
want to dig deeper into the code, [here][link-to-the-code] is the link of the
final version of the project


## Conclusions

Creating a video is a fun task and doing it using code is even better!

This tutorial proves that you don't need to be a Python expert to generate a
video using code from scratch. This is one of the advantages of Python as a
language. It's useful beyond tasks like web development, data science or
machine learning. Its versatility allows you to accomplish tasks like
rendering customized images and videos with an easy to understand syntax so
you can start using it if you have any programming experience with other
languages.

Creating multimedia content with code might be tricky at the beginning, but
once you get started it's hard to stop adding multiple animations or new
segments.

Following this tutorial step by step gives the basic concepts needed to start
using Moviepy, SciPy and ImageMagick with Python to experiment with videos or image
rendering. Animating video objects with these libraries is also doable adding
just a bit of complexity in the calculations.

-- TODO: update readme url, video gif url, and link to the code to point to new repo

[django]: https://www.djangoproject.com
[flask]: http://flask.pocoo.org/
[moviepy]: https://zulko.github.io/moviepy/
[readme]: https://github.com/stackbuilders/tutorials/blob/tutorials/tutorials/python/python-video-generation/code/Readme.md 
[ffmpeg]: https://ffmpeg.org/
[link-to-the-code]: https://github.com/stackbuilders/tutorials/tree/tutorials/tutorials/python/python-video-generation/code
[txt-clip]: https://moviepy-tburrows13.readthedocs.io/en/improve-docs/ref/VideoClip/TextClip.html
[scipy]: https://scipy.org/
[imagemagick]: https://imagemagick.org/
[mpy-segmenting]: https://zulko.github.io/moviepy/ref/videotools.html#moviepy.video.tools.segmenting.findObjects