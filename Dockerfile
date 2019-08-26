# 開発環境向け

# as をつけることでビルド環境に命名を追加
FROM node:10.16.1-alpine as dev-env
WORKDIR /app
COPY . /app
RUN apk update
RUN yarn
EXPOSE 3000
CMD ["yarn", "dev"]

# ビルド環境向け

# as をつけることでビルド環境に命名を追加
FROM node:10.16.1-alpine as build-env
WORKDIR /app
COPY . /app
RUN apk update
RUN yarn
RUN yarn build

# 本番環境向け

# メインのイメージは特に何もつけなくて良い
FROM node:10.16.1-alpine

WORKDIR /app
COPY . /app

# 別のビルドから成果物をコピー可能
COPY --from=build-env /app/.nuxt /app/.nuxt

# 本番では devDeps を消してファイルサイズを削減
RUN yarn install --production
EXPOSE 3000
CMD ["yarn", "start"]
