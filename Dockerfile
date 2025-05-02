# Use a stable Node.js image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy only package.json and package-lock.json first (for caching)
COPY package*.json ./

# Install dependencies (this includes bootstrap)
RUN npm install

# Copy all source files
COPY . .

# Build the production version
RUN npm run build

# Expose the port your app runs on
EXPOSE 3000

# Default command
CMD ["npm", "start"]

