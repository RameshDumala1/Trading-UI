FROM node:18-alpine

# Install serve globally
RUN npm install -g serve

# Create app directory
WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm install

# Copy rest of the app
COPY . .

# Build the React/Vite app
RUN npm run build

# Expose port and serve the app
EXPOSE 3000
CMD ["serve", "-s", "dist", "-l", "3000"]
