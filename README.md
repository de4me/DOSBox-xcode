
# DOSBox for macOS

[![Downloads](https://img.shields.io/github/downloads/de4me/DOSBox-xcode/total.svg)](https://github.com/de4me/DOSBox-xcode/releases)
[![github stars](https://img.shields.io/github/stars/de4me/DOSBox-xcode.svg)](https://github.com/de4me/DOSBox-xcode/stargazers)

# FEATURES

1) Support form modern macOS;
2) Multiple display support;
3) DOSBox Application package (Run dos application with double click);
4) Bug fixes and improvements;

# BUILD

cd ~/Desktop/
git clone https://github.com/de4me/DOSBox-xcode.git DOSBox-xcode
cd ~/Desktop/DOSBox-xcode/submodules/
git clone --branch "SDL-1.2" https://github.com/de4me/SDL_net-xcode.git SDL_net
cd SDL_net/submodules
git clone https://github.com/de4me/SDL-1.2-xcode.git SDL
cd ~/Desktop/DOSBox-xcode/submodules/
git clone --branch "stable-1.0" https://github.com/de4me/SDL_sound-xcode.git SDL_sound
cd SDL_sound/submodules
git clone https://github.com/de4me/SDL-1.2-xcode.git SDL
git clone https://github.com/de4me/flac-xcode.git flac
git clone https://github.com/de4me/mpg123-xcode.git mpg123
git clone https://github.com/de4me/vorbis-xcode.git vorbis
cd vorbis/submodules
git clone https://github.com/de4me/ogg-xcode.git ogg

Now you can Open ~/Desktop/DOSBox-xcode/Xcode/DOSBox.xcworkspace and build.

# TROUBLESHOOTING

If there is a build error, check the versions of the submodules and update them to the current version.

# DOSBox

DOSBox is a DOS-emulator that uses the SDL-library which makes DOSBox very easy to port to different platforms. DOSBox has already been ported to many different platforms, such as Windows, BeOS, Linux, MacOS X...

DOSBox also emulates CPU:286/386 realmode/protected mode, Directory FileSystem/XMS/EMS, Tandy/Hercules/CGA/EGA/VGA/VESA graphics, a SoundBlaster/Gravis Ultra Sound card for excellent sound compatibility with older games...

You can "re-live" the good old days with the help of DOSBox, it can run plenty of the old classics that don't run on your new computer!

DOSBox is totally free of charge and Open Source.

Check our Downloads page for the most recent DOSBox version.

Original project: https://www.dosbox.com/

Thanks!
