# Stage 1: Build React app
FROM node:20-alpine AS build
WORKDIR /app
ARG REACT_APP_API_BASE
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine
RUN addgroup -S www && adduser -D -g www appuser

# Copy your custom nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Copy your built React app
COPY --from=build /app/build /usr/share/nginx/html

# Change ownership of the HTML directory to the new user
RUN chown -R appuser:www /usr/share/nginx/html

# Switch to the non-root user
USER appuser

EXPOSE 80
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
