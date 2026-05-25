# # Use Node.js as the base image
# FROM node:18

# # Set working directory
# WORKDIR /app

# # Copy package.json and package-lock.json
# COPY package.json package-lock.json ./

# # Install dependencies

# # Copy the entire project to the container
# COPY . .

# # Expose React's default port


# # Start the React application
# RUN npm install | npm install pm2 -g
# #CMD [ "node", "app.js" ]
# CMD ["pm2-runtime", "app.js"]
# EXPOSE 3000



# Stage 1: Build the optimized static assets
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Serve the compiled static assets using a clean Nginx instance
FROM nginx:alpine
# Copy the compiled production build assets into Nginx's public web directory
COPY --from=builder /app/dist /usr/share/nginx/html/omnivison-app
# Copy custom fallback inner routing logic
COPY nginx.frontend.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]