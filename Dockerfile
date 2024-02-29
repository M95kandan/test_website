FROM centos:7

# Install git
RUN yum install -y git httpd

# Clone the repo
RUN git clone https://M95kandan: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@github.com/M95kandan/test_website.git 

RUN mv test_website /var/www/html

# Expose port 80
EXPOSE 80

# Set the working directory
WORKDIR /var/www/html/

# Start the Apache server
CMD ["httpd", "-D", "FOREGROUND"]
