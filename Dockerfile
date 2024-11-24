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

# Production stage: Use httpd (Apache) image for serving the app
FROM httpd:alpine AS production

# Copy the build output to the Apache document root
COPY --from=build /app/build /usr/local/apache2/htdocs/
RUN mkdir -p /usr/local/apache2/logs
RUN chmod -R 777 /usr/local/apache2

# Ubah Apache untuk mendengarkan di port 8080
RUN sed -i 's/Listen 80/Listen 8080/' /usr/local/apache2/conf/httpd.conf

# Set the server name to suppress warnings
RUN echo 'ServerName 127.0.0.1' >> /usr/local/apache2/conf/httpd.conf

# Expose port 8080
EXPOSE 8080

# Set the entrypoint to keep the Apache server running
CMD ["httpd-foreground"]
