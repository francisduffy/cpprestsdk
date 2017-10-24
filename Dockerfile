ARG boost_version=latest
FROM build_env_boost:${boost_version}

MAINTAINER Francis Duffy
LABEL Description="Build cpprestsdk on top of my boost development image"

# Argument for number of cores to use while building
ARG num_cores=1

# Exclusions are performed by .dockerignore
COPY Release /cpprestsdk/Release

# Get cmake and libssl-dev, then build Release version
RUN apt-get update \
  && apt-get install -y libssl-dev cmake \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && cd /cpprestsdk/Release \
  && mkdir build.release \
  && cd build.release \
  && cmake .. -DCMAKE_BUILD_TYPE=Release -DWERROR=OFF \
  && make -j ${num_cores} \
  && make install \
  && cd / \
  && rm -rf cpprestsdk \
  && ldconfig

CMD bash