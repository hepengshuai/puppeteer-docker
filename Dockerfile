FROM alpine:edge

# 安装最新版 Chromium(89) 的包
RUN apk add --no-cache \
      chromium \
      nss \
      freetype \
      harfbuzz \
      ca-certificates \
      ttf-freefont \
      nodejs \
      npm \
      yarn

# 跳过自动安装 Chrome 包. 使用上面已经安装的 Chrome
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

RUN yarn add puppeteer


# 通过 yarn 设置淘宝源和装包，并清除缓存
RUN yarn config set registry 'https://registry.npm.taobao.org' && \
    yarn install && \
    yarn cache clean

RUN mkdir -p /workspace/data/origin \
    && mkdir -p /workspace/data/gzip

WORKDIR /workspace

ADD *.json ./
ADD *.js ./
RUN npm install

EXPOSE 9000

ENTRYPOINT ["node", "app.js"]
