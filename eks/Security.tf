# Define the Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id                   = aws_vpc.hydroscope-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


