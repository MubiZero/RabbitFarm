FROM node:20-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache netcat-openbsd

COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Create uploads directory
RUN mkdir -p uploads logs

# Make entrypoint executable
RUN chmod +x entrypoint.sh

# Set environment variables
ENV NODE_ENV=production
ENV PORT=4567

# Expose port
EXPOSE 4567

# Start the application via entrypoint
ENTRYPOINT ["./entrypoint.sh"]
