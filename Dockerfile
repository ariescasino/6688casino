# Sử dụng image Node.js chính thức làm image cơ sở
FROM node:18

# Cài đặt công cụ zip để nén tệp
RUN apt-get update && apt-get install -y zip

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Sao chép các tệp package.json và package-lock.json
COPY package*.json ./

# Cài đặt các gói phụ thuộc bằng npm
RUN npm install

# Sao chép toàn bộ mã nguồn của dự án
COPY . .

# Sao chép tệp môi trường mẫu (nếu có)
COPY env.example .env

# Build ứng dụng
RUN npm run build

# Nén các tệp cần thiết cho việc triển khai vào file deploy.zip
# Bạn có thể thay đổi thư mục "out" thành "build" nếu dự án của bạn dùng tên đó
RUN zip -r deploy.zip ./out ./node_modules ./package.json ./.env