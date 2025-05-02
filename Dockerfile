# Use Node.js base image
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm install

# Copy rest of the app
COPY . .

# Build static files (if using React/Vite/etc)
RUN npm run build

# Expose port and run
EXPOSE 3000
CMD ["npm", "start"]
