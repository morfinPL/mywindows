$WINDOWS_VERSION=":ltsc2019-amd64"
$GIT_VERSION="2.39.2"
$PYTHON_VERSION="3.11.2"
$CMAKE_VERSION="3.25.2"
$VS_BUILDTOOLS_VERSION="16"
$OPENCV_VERSION="4.7.0"
$CATCH_VERSION="v3.3.1"

docker build -t morfin/mywindows:Git_$($GIT_VERSION)_Python_$($PYTHON_VERSION)_CMake_$($CMAKE_VERSION)_VS_$($VS_BUILDTOOLS_VERSION) `
    --build-arg WINDOWS_VERSION=$WINDOWS_VERSION `
    --build-arg GIT_VERSION=$GIT_VERSION `
    --build-arg PYTHON_VERSION=$PYTHON_VERSION `
    --build-arg CMAKE_VERSION=$CMAKE_VERSION `
    --build-arg VS_BUILDTOOLS_VERSION=$VS_BUILDTOOLS_VERSION `
    .

docker build -t morfin/mywindows:Git_$($GIT_VERSION)_Python_$($PYTHON_VERSION)_CMake_$($CMAKE_VERSION)_VS_$($VS_BUILDTOOLS_VERSION)_OpenCV_$($OPENCV_VERSION)_Release `
    --build-arg WINDOWS_VERSION=$WINDOWS_VERSION `
    --build-arg GIT_VERSION=$GIT_VERSION `
    --build-arg PYTHON_VERSION=$PYTHON_VERSION `
    --build-arg CMAKE_VERSION=$CMAKE_VERSION `
    --build-arg VS_BUILDTOOLS_VERSION=$VS_BUILDTOOLS_VERSION `
    --build-arg BUILD_TYPE=RELEASE `
    --build-arg BUILD_OPENCV=ON `
    --build-arg OPENCV_VERSION=$OPENCV_VERSION `
    .

docker build -t morfin/mywindows:Git_$($GIT_VERSION)_Python_$($PYTHON_VERSION)_CMake_$($CMAKE_VERSION)_VS_$($VS_BUILDTOOLS_VERSION)_OpenCV_$($OPENCV_VERSION)_Catch_$($CATCH_VERSION)_Release `
    --build-arg WINDOWS_VERSION=$WINDOWS_VERSION `
    --build-arg GIT_VERSION=$GIT_VERSION `
    --build-arg PYTHON_VERSION=$PYTHON_VERSION `
    --build-arg CMAKE_VERSION=$CMAKE_VERSION `
    --build-arg VS_BUILDTOOLS_VERSION=$VS_BUILDTOOLS_VERSION `
    --build-arg BUILD_TYPE=RELEASE `
    --build-arg BUILD_OPENCV=ON `
    --build-arg OPENCV_VERSION=$OPENCV_VERSION `
    --build-arg BUILD_CATCH=ON `
    --build-arg CATCH_VERSION=$CATCH_VERSION `
    .

docker build -t morfin/mywindows:Git_$($GIT_VERSION)_Python_$($PYTHON_VERSION)_CMake_$($CMAKE_VERSION)_VS_$($VS_BUILDTOOLS_VERSION)_OpenCV_$($OPENCV_VERSION)_Debug `
    --build-arg WINDOWS_VERSION=$WINDOWS_VERSION `
    --build-arg GIT_VERSION=$GIT_VERSION `
    --build-arg PYTHON_VERSION=$PYTHON_VERSION `
    --build-arg CMAKE_VERSION=$CMAKE_VERSION `
    --build-arg VS_BUILDTOOLS_VERSION=$VS_BUILDTOOLS_VERSION `
    --build-arg BUILD_TYPE=DEBUG `
    --build-arg BUILD_OPENCV=ON `
    --build-arg OPENCV_VERSION=$OPENCV_VERSION `
    .

docker build -t morfin/mywindows:Git_$($GIT_VERSION)_Python_$($PYTHON_VERSION)_CMake_$($CMAKE_VERSION)_VS_$($VS_BUILDTOOLS_VERSION)_OpenCV_$($OPENCV_VERSION)_Catch_$($CATCH_VERSION)_Debug `
    --build-arg WINDOWS_VERSION=$WINDOWS_VERSION `
    --build-arg GIT_VERSION=$GIT_VERSION `
    --build-arg PYTHON_VERSION=$PYTHON_VERSION `
    --build-arg CMAKE_VERSION=$CMAKE_VERSION `
    --build-arg VS_BUILDTOOLS_VERSION=$VS_BUILDTOOLS_VERSION `
    --build-arg BUILD_TYPE=DEBUG `
    --build-arg BUILD_OPENCV=ON `
    --build-arg OPENCV_VERSION=$OPENCV_VERSION `
    --build-arg BUILD_CATCH=ON `
    --build-arg CATCH_VERSION=$CATCH_VERSION `
    .

docker build -t morfin/mywindows:Git_$($GIT_VERSION)_Python_$($PYTHON_VERSION)_CMake_$($CMAKE_VERSION)_VS_$($VS_BUILDTOOLS_VERSION)_OpenCV_$($OPENCV_VERSION)_Release_Debug `
    --build-arg WINDOWS_VERSION=$WINDOWS_VERSION `
    --build-arg GIT_VERSION=$GIT_VERSION `
    --build-arg PYTHON_VERSION=$PYTHON_VERSION `
    --build-arg CMAKE_VERSION=$CMAKE_VERSION `
    --build-arg VS_BUILDTOOLS_VERSION=$VS_BUILDTOOLS_VERSION `
    --build-arg BUILD_TYPE=RELEASE_DEBUG `
    --build-arg BUILD_OPENCV=ON `
    --build-arg OPENCV_VERSION=$OPENCV_VERSION `
    .

docker build -t morfin/mywindows:Git_$($GIT_VERSION)_Python_$($PYTHON_VERSION)_CMake_$($CMAKE_VERSION)_VS_$($VS_BUILDTOOLS_VERSION)_OpenCV_$($OPENCV_VERSION)_Catch_$($CATCH_VERSION)_Release_Debug `
    --build-arg WINDOWS_VERSION=$WINDOWS_VERSION `
    --build-arg GIT_VERSION=$GIT_VERSION `
    --build-arg PYTHON_VERSION=$PYTHON_VERSION `
    --build-arg CMAKE_VERSION=$CMAKE_VERSION `
    --build-arg VS_BUILDTOOLS_VERSION=$VS_BUILDTOOLS_VERSION `
    --build-arg BUILD_TYPE=RELEASE_DEBUG `
    --build-arg BUILD_OPENCV=ON `
    --build-arg OPENCV_VERSION=$OPENCV_VERSION `
    --build-arg BUILD_CATCH=ON `
    --build-arg CATCH_VERSION=$CATCH_VERSION `
    .
