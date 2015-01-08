# set the binaries that have to be built
TARGETS := m_DenseTrackStab Video

# set the build configuration set 
BUILD := release
#BUILD := debug

# set bin and build dirs
BUILDDIR := .build_$(BUILD)
BINDIR := $(BUILD)



# FFMPEG_INCL=/users/omkar/arnie/include/
# OPENCV_INCL=/users/omkar/arnie/include/
# OPENCV_LIBS=/users/omkar/arnie/lib/

#FFMPEG_INCL=/home/minhhoai/local/ffmpeg_build/include/
OPENCV_INCL=/usr/local/include/
OPENCV_LIBS=/usr/local/lib/

# libraries 
LDLIBS = $(addprefix -l, $(LIBS) $(LIBS_$(notdir $*)))
LIBS := \
	opencv_core opencv_highgui opencv_video opencv_imgproc opencv_calib3d opencv_features2d opencv_nonfree \
	avformat avdevice avutil avcodec swscale

# set some flags and compiler/linker specific commands
##-I$(FFMPEG_INCL)
CXXFLAGS = -pipe -D __STDC_CONSTANT_MACROS -D STD=std -Wall $(CXXFLAGS_$(BUILD)) -I. -I/opt/include  -I$(OPENCV_INCL)
CXXFLAGS_debug := -ggdb
CXXFLAGS_release := -O3 -DNDEBUG -ggdb
#LDFLAGS = -L/opt/lib -pipe -Wall -L$(OPENCV_LIBS) $(LDFLAGS_$(BUILD))
#-L/home/minhhoai/local/ffmpeg_build/lib/
LDFLAGS =  -pipe -Wall -L$(OPENCV_LIBS) $(LDFLAGS_$(BUILD))
LDFLAGS_debug := -ggdb
LDFLAGS_release := -O3 -ggdb

include make/generic.mk
