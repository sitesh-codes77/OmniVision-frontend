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
# Note: Since you updated to npm install earlier, you can keep npm install here if npm ci fails
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve the compiled static assets using a clean Nginx instance
FROM nginx:alpine
# ✅ FIX: Copy the assets directly into Nginx's main web root folder, NOT a subfolder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom fallback inner routing logic
COPY nginx.frontend.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]