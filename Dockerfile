# Gunakan node image sebagai base untuk build stage
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Salin package.json dan package-lock.json
COPY package*.json ./

# Instal dependensi
RUN npm install

# Salin seluruh kode aplikasi
COPY . .

# Build aplikasi untuk production
RUN npm run build

# Gunakan nginx untuk production stage
FROM nginx:alpine
RUN chmod -R 777 /var
RUN chown -R 1002710000:0 /var 

# Salin build output ke NGINX public folder
COPY --from=build /app/build /usr/share/nginx/html

# Ekspose port 80
EXPOSE 80

# Jalankan NGINX
CMD ["nginx", "-g", "daemon off;"]

