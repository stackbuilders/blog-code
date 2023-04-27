# Local environment set up

---

## Before Getting Started

Make sure you have
[Cairo](https://pycairo.readthedocs.io/en/latest/getting_started.html) installed
locally if you want to run the script file `python_video_with_gize.py`. `Gizeh` lib requires it. Follow the instruction in the link.


## Install ImageMagick

ImageMagick is required to run `python_video.py` for creating `Moviepy` [`TextClip`s](https://moviepy-tburrows13.readthedocs.io/en/improve-docs/ref/VideoClip/TextClip.html#textclip).

You can download the source binaries [here](https://imagemagick.org/script/download.php) and follow your development environment section to install from source. Otherwise, you can use a system package manager for the desired OS as follows.

To verify ImageMagick installation you can run the following command that will create a gif file.
```bash
$ convert logo: logo.gif
```

### Ubuntu
Your distribution may already have installed ImageMagick. But in case its not, type:
```bash
$ sudo apt install imagemagick
```

### MacOS
Using [Homebrew](https://brew.sh/) which provides pre-built binaries for Mac, type:
```bash
$ brew install imagemagick
```
ImageMagick depends on Ghostscript fonts. To install them, type:
```bash
$ brew install ghostscript
```

### Windows
The Windows version of ImageMagick is self-installing. Simply go to the [download page](https://imagemagick.org/script/download.php) to get a version that will launch itself and ask a few installation questions.

## Install Python 3

### Linux and OSX

Using version manager [asdf-vm](https://asdf-vm.com/#/core-manage-asdf-vm?id=install-asdf-vm):

##### Install [Python Plugin](https://github.com/danhper/asdf-python):

```bash
$ asdf plugin-add python https://github.com/danhper/asdf-python.git
```

##### Install Python:

Python version is specified in `.tools-versions` file.

```bash
$ asdf install
```

**Note:** This can be installed using package managers as well, the instruction
may vary according to your package manager:

- In Ubuntu:

```bash
sudo apt-get install python3
```

- In OSx:

```bash
brew install python3
```

### Windows

Using package manager [Chocolatey](https://chocolatey.org/)

```bash
C:\> choco install python3
```

## Install python package manager

If not installed yet, run from the root of the project to install `pipenv`:

```bash
$ pip install --user pipenv
```
## Install dependencies

From root project directory run:

```bash
$ pipenv install
```

### Enable your virtual environment

From root project folder, enable virtual env typing

```bash
pipenv shell
```

### To generate the video

With pipenv virtualenv enabled and from the root project folder run

```bash
python moviepy_video.py
```

**Note:** It's possible to execute the script directly with `pipenv` using:

```bash
pipenv run python python_video.py
```

### Disable Virtual Environment

To Disable it type `exit`

### Troubleshooting

If you encounter errors linking `ImageMagick` binaries like in this [issue 693](https://github.com/Zulko/moviepy/issues/693), it does not have the proper permission set.

Check for the ImageMagick policy file at
`/etc/ImageMagick-6/policy.xml` and comment out (or remove the line that reads)

```
<policy domain="path" rights="none" pattern="@*" />
```
```
<!-- <policy domain="path" rights="none" pattern="@*" /> -->
```