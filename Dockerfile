ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows$WINDOWS_VERSION

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Register-PackageSource -Name Nuget -Location "http://www.nuget.org/api/v2" -ProviderName Nuget -Trusted -Force

RUN Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

ARG VS_BUILDTOOLS_VERSION
RUN Invoke-WebRequest "https://aka.ms/vs/$env:VS_BUILDTOOLS_VERSION/release/vs_BuildTools.exe" -OutFile vs_BuildTools.exe; \
    Start-Process -FilePath 'vs_BuildTools.exe' -ArgumentList '--quiet', '--norestart', '--locale en-US', '--add Microsoft.VisualStudio.Workload.VCTools', '--includeRecommended' -Wait; \
    Remove-Item .\vs_BuildTools.exe; \
    Remove-Item -Force -Recurse 'C:\Program Files (x86)\Microsoft Visual Studio\Installer'

ARG PYTHON_VERSION
RUN Install-Package -Name python -RequiredVersion $env:PYTHON_VERSION; \
    [Environment]::SetEnvironmentVariable('PATH' , \
    'C:\Program Files\PackageManagement\NuGet\Packages\python.' + $env:PYTHON_VERSION + '\tools;' \
    + [System.Environment]::GetEnvironmentVariable('Path', 'User'), [EnvironmentVariableTarget]::User)

ARG CMAKE_VERSION
RUN Invoke-WebRequest "https://github.com/Kitware/CMake/releases/download/v$env:CMAKE_VERSION/cmake-$env:CMAKE_VERSION-windows-x86_64.msi" -OutFile 'cmake_installer.msi'; \
    Start-Process .\cmake_installer.msi -ArgumentList '/norestart' -Wait; \
    Remove-Item cmake_installer.msi; \
    [Environment]::SetEnvironmentVariable('PATH' , \
    'C:\Program Files\cmake\bin;' \
    + [System.Environment]::GetEnvironmentVariable('Path', 'User'), [EnvironmentVariableTarget]::User)

RUN python -m pip install --upgrade pip; python -m pip install numpy

# For server image you need to install Media Foundation
# RUN Install-WindowsFeature Server-Media-Foundation

ARG GIT_VERSION
RUN Install-Package -Name GitForWindows -RequiredVersion $env:GIT_VERSION; \
    [Environment]::SetEnvironmentVariable('PATH' , \
    'C:\Program Files\PackageManagement\NuGet\Packages\GitForWindows.' + $env:GIT_VERSION + '\tools\cmd;' \
    + [System.Environment]::GetEnvironmentVariable('Path', 'User'), [EnvironmentVariableTarget]::User)

ARG BUILD_TYPE

# Install OpenCV
ARG BUILD_OPENCV
ARG OPENCV_VERSION
RUN if (($env:BUILD_OPENCV -ieq 'ON') -and (($env:BUILD_TYPE -ieq 'DEBUG') -or ($env:BUILD_TYPE -ieq 'RELEASE_DEBUG'))) { \
    git clone https://github.com/opencv/opencv_contrib.git ; \
    cd opencv_contrib ; \
    git checkout $env:OPENCV_VERSION ; \
    cd .. ; \
    git clone https://github.com/opencv/opencv.git ; \
    cd opencv ; \
    git checkout $env:OPENCV_VERSION ; \
    mkdir buildD ; \
    cd buildD ; \
    cmake \
      -D CMAKE_BUILD_TYPE=DEBUG  \
      -D CMAKE_INSTALL_PREFIX=C:\Dev\OpenCV \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D INSTALL_C_EXAMPLES=OFF \
      -D WITH_FFMPEG=ON \
      -D WITH_TBB=ON \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_opencv_apps=OFF \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D BUILD_opencv_python2=OFF \
      -D PYTHON3_INCLUDE_DIR=$(python -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())') \
      -D PYTHON3_PACKAGES_PATH=$(python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())') \
      -D PYTHON3_EXECUTABLE=$((Get-Command python).Path) \
      -D PYTHON_DEFAULT_EXECUTABLE=$((Get-Command python).Path) \
      -S .. -B . ; \
    cmake --build . --config Debug -j $(Get-WmiObject -class Win32_processor).NumberOfLogicalProcessors ; cmake --install . --config Debug ; cd ..\.. ; \
    cd ..\.. ; \
    Remove-Item -Recurse -Force opencv ; \
    Remove-Item -Recurse -Force opencv_contrib ; \
    [Environment]::SetEnvironmentVariable('OpenCV_DIR' , 'C:\Dev\OpenCV', [EnvironmentVariableTarget]::User) ; \
    [Environment]::SetEnvironmentVariable('PATH' , 'C:\Dev\OpenCV\x64\vc' + $env:VS_BUILDTOOLS_VERSION + '\bin;' \
    + [System.Environment]::GetEnvironmentVariable('Path', 'User'), [EnvironmentVariableTarget]::User) ; \
    }
RUN if (($env:BUILD_OPENCV -ieq 'ON') -and (($env:BUILD_TYPE -ieq 'RELEASE') -or ($env:BUILD_TYPE -ieq 'RELEASE_DEBUG'))) { \
    git clone https://github.com/opencv/opencv_contrib.git ; \
    cd opencv_contrib ; \
    git checkout $env:OPENCV_VERSION ; \
    cd .. ; \
    git clone https://github.com/opencv/opencv.git ; \
    cd opencv ; \
    git checkout $env:OPENCV_VERSION ; \
    mkdir buildR ; \
    cd buildR ; \
    cmake \
      -D CMAKE_BUILD_TYPE=RELEASE  \
      -D CMAKE_INSTALL_PREFIX=C:\Dev\OpenCV \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D INSTALL_C_EXAMPLES=OFF \
      -D WITH_FFMPEG=ON \
      -D WITH_TBB=ON \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_opencv_apps=OFF \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D BUILD_opencv_python2=OFF \
      -D PYTHON3_INCLUDE_DIR=$(python -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())') \
      -D PYTHON3_PACKAGES_PATH=$(python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())') \
      -D PYTHON3_EXECUTABLE=$((Get-Command python).Path) \
      -D PYTHON_DEFAULT_EXECUTABLE=$((Get-Command python).Path) \
      -S .. -B . ; \
    cmake --build . --config Release -j $(Get-WmiObject -class Win32_processor).NumberOfLogicalProcessors ; cmake --install . --config Release ; cd ..\.. ; \
    cd ..\.. ; \
    Remove-Item -Recurse -Force opencv ; \
    Remove-Item -Recurse -Force opencv_contrib ; \
    [Environment]::SetEnvironmentVariable('OpenCV_DIR' , 'C:\Dev\OpenCV', [EnvironmentVariableTarget]::User) ; \
    [Environment]::SetEnvironmentVariable('PATH' , 'C:\Dev\OpenCV\x64\vc' + $env:VS_BUILDTOOLS_VERSION + '\bin;' \
    + [System.Environment]::GetEnvironmentVariable('Path', 'User'), [EnvironmentVariableTarget]::User) ; \
    }

# Install Catch
ARG BUILD_CATCH
ARG CATCH_VERSION
RUN if (($env:BUILD_CATCH -ieq 'ON') -and (($env:BUILD_TYPE -ieq 'DEBUG') -or ($env:BUILD_TYPE -ieq 'RELEASE_DEBUG'))) { \
    git clone https://github.com/catchorg/Catch2.git ; \
    cd Catch2 ; \
    git checkout $env:CATCH_VERSION ; cd .. ; \
    mkdir buildD ; \
    cd buildD ; \
    cmake -D CMAKE_BUILD_TYPE=DEBUG \
      -D CMAKE_INSTALL_PREFIX=C:\Dev\Catch2 \
      ../Catch2 ; \
    cmake --build . --config Debug -j $(Get-WmiObject -class Win32_processor).NumberOfLogicalProcessors ; cmake --install . --config Debug ; cd .. ; \
    Remove-Item -Recurse -Force Catch2 ; \
    Remove-Item -Recurse -Force buildD ; \
    [Environment]::SetEnvironmentVariable('Catch2_DIR' , 'C:\Dev\Catch2\lib\cmake\Catch2', [EnvironmentVariableTarget]::User) ; \
    }
RUN if (($env:BUILD_CATCH -ieq 'ON') -and (($env:BUILD_TYPE -ieq 'RELEASE') -or ($env:BUILD_TYPE -ieq 'RELEASE_DEBUG'))) { \
    git clone https://github.com/catchorg/Catch2.git ; \
    cd Catch2 ; \
    git checkout $env:CATCH_VERSION ; cd .. ; \
    mkdir buildR ; \
    cd buildR ; \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=C:\Dev\Catch2 \
      ../Catch2 ; \
    cmake --build . --config Release -j $(Get-WmiObject -class Win32_processor).NumberOfLogicalProcessors ; cmake --install . --config Release ; cd .. ; \
    Remove-Item -Recurse -Force Catch2 ; \
    Remove-Item -Recurse -Force buildR ; \
    [Environment]::SetEnvironmentVariable('Catch2_DIR' , 'C:\Dev\Catch2\lib\cmake\Catch2', [EnvironmentVariableTarget]::User) ; \
    }
