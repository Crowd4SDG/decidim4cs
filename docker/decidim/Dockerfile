FROM decidim/decidim:0.24.3

ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
RUN chown -R $USER_ID:$GROUP_ID /usr/local/bundle
RUN npm install --global yarn
USER user

CMD ["/usr/bin/bash"]

