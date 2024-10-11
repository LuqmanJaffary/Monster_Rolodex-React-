# Stage 1: Use Node.js to install dependencies and build the app
FROM node:18-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install npm dependencies
RUN npm install

# Copy the rest of the app files
COPY . .

# Build the production-ready app
RUN npm run build

# Stage 2: Use Nginx to serve the built app
FROM nginx:stable-alpine

# Copy built app from the previous stage to Nginx's default html directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
