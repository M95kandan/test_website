FROM httpd:2.4

# Install git 
RUN apt-get update && apt-get install -y git

# Copy website files
ADD https://github.com/M95kandan/test_website.git /var/www/html/

# Expose port 80
EXPOSE 80
