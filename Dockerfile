ARG openssl_version=latest
ARG boost_version=latest

FROM openssl:${openssl_version} as env_openssl

FROM build_env_boost:${boost_version}

ARG num_cores

COPY . /cpprestsdk

# Copy the openssl and zlib elements from env_openssl
COPY --from=env_openssl /usr/local/lib /usr/local/lib
COPY --from=env_openssl /usr/local/include /usr/local/include

RUN cd /cpprestsdk \
  && mkdir build.release \
  && cd build.release \
  && cmake .. -DCMAKE_BUILD_TYPE=Release -DWERROR=OFF \
  && make -j ${num_cores} \
  && make install \
  && cd / \
  && rm -rf cpprestsdk \
  && ldconfig

CMD bash
