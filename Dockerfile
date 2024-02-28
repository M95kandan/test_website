FROM centos:7

# Install git
RUN yum install -y git httpd

# Clone the repo
RUN git clone https://github.com/M95kandan/test_website.git /var/www/html/

# Expose port 80
EXPOSE 80

# Set the working directory
WORKDIR /var/www/html/

# Start the Apache server
CMD ["httpd", "-D", "FOREGROUND"]
