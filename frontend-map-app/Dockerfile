# Use Node.js 18 as the base image
FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the project files
COPY . .

# Build the Next.js app
RUN npm run build

# Use a minimal Node.js image for production
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy built files from previous stage
COPY --from=builder /app ./

# Expose the port Next.js runs on
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "run","dev"]
