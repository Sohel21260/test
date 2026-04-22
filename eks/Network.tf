resource "aws_vpc" "hydroscope-vpc" {
  cidr_block       = "10.0.0.0/21"
  instance_tenancy = "default"
  enable_dns_support   = true   
  enable_dns_hostnames = true   

  tags = {
    Name = "hydroscope-vpc"
    Project= "hydroscope"

  }
}
# subnet

resource "aws_subnet" "Private-subnet-1" {
  vpc_id                  = aws_vpc.hydroscope-vpc.id
  cidr_block              = "10.0.0.0/24" 
  availability_zone       = "ap-south-1a"   

  tags = {
    Name = "Private-subnet-1"
    Project= "hydroscope"
  }
}

resource "aws_subnet" "Private-subnet-2" {
  vpc_id                  = aws_vpc.hydroscope-vpc.id
  cidr_block              = "10.0.1.0/24" 
  availability_zone       = "ap-south-1b"   

  tags = {
    Name = "Private-subnet-2"
    Project= "hydroscope"
  }
}
resource "aws_subnet" "Private-subnet-3" {
  vpc_id                  = aws_vpc.hydroscope-vpc.id
  cidr_block              = "10.0.2.0/24" 
  availability_zone       = "ap-south-1c"   

  tags = {
    Name = "Private-subnet-3"
    Project= "hydroscope"
  }
}

resource "aws_subnet" "Public-subnet-1" {
  vpc_id                  = aws_vpc.hydroscope-vpc.id
  cidr_block              = "10.0.3.0/24" 
  availability_zone       = "ap-south-1a"   
  map_public_ip_on_launch = true 

  tags = {
    Name = "Public-subnet-1"
    Project= "hydroscope"
  }
}
resource "aws_subnet" "Public-subnet-2" {
  vpc_id                  = aws_vpc.hydroscope-vpc.id
  cidr_block              = "10.0.4.0/24" 
  availability_zone       = "ap-south-1b"   
  map_public_ip_on_launch = true 
  tags = {
    Name = "Public-subnet-2"
    Project= "hydroscope"
  }
}
resource "aws_subnet" "Public-subnet-3" {
  vpc_id                  = aws_vpc.hydroscope-vpc.id
  cidr_block              = "10.0.5.0/24" 
  availability_zone       = "ap-south-1c"   
  map_public_ip_on_launch = true 
  tags = {
    Name = "Public-subnet-3"
    Project= "hydroscope"
  }
}
# igw
resource "aws_internet_gateway" "hydroscope-igw" {
  vpc_id = aws_vpc.hydroscope-vpc.id

  tags = {
    Name = "appsever-igw"
    Project= "hydroscope"
  }
}
#  Elastic IP
resource "aws_eip" "hydroscope-eip" {
  domain = "vpc"
  tags = {
    Name = "appserver-eip"
    Project= "hydroscope"
  }
}
#  Public Route Table
resource "aws_route_table" "hydroscope-route-table-public" {
  vpc_id = aws_vpc.hydroscope-vpc.id

  tags = {
    Name = "app-route-table-public"
    Project= "hydroscope"
  }
}
# Route
resource "aws_route" "app-route-public" {
  route_table_id         = aws_route_table.hydroscope-route-table-public.id
  destination_cidr_block = "0.0.0.0/0"  
  gateway_id             = aws_internet_gateway.hydroscope-igw.id
}
# Route table assosiation public
resource "aws_route_table_association" "hydroscope-route-table-association-public" {
  subnet_id      = aws_subnet.Public-subnet-1.id
  route_table_id = aws_route_table.hydroscope-route-table-public.id
}
# Route table assosiation public
resource "aws_route_table_association" "hydroscope-route-table-association-public-1" {
  subnet_id      = aws_subnet.Public-subnet-2.id
  route_table_id = aws_route_table.hydroscope-route-table-public.id
}
# Route table assosiation public
resource "aws_route_table_association" "hydroscope-route-table-association-public-2" {
  subnet_id      = aws_subnet.Public-subnet-3.id
  route_table_id = aws_route_table.hydroscope-route-table-public.id
}
# NAT Gateway
resource "aws_nat_gateway" "hydroscope-nat-gateway" {
  allocation_id = aws_eip.hydroscope-eip.id
  subnet_id    = aws_subnet.Public-subnet-1.id  

  tags = {
    Name = "hydroscope-nat-gateway"
    Project= "hydroscope"
  }
}


# Private Route table

resource "aws_route_table" "hydroscope-route-table-private" {
  vpc_id = aws_vpc.hydroscope-vpc.id
     tags = {
    Name = "app-route-table-private"
    Project= "hydroscope"
  }
}
resource "aws_route" "route_0" {
  route_table_id         = aws_route_table.hydroscope-route-table-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.hydroscope-nat-gateway.id
}



# Route Table assosiation private-App
resource "aws_route_table_association" "private-subnet-app-association" {
  subnet_id      = aws_subnet.Private-subnet-1.id
  route_table_id = aws_route_table.hydroscope-route-table-private.id
}
# Route Table assosiation private-DB
resource "aws_route_table_association" "private-subnet-DB-association" {
  subnet_id      = aws_subnet.Private-subnet-2.id
  route_table_id = aws_route_table.hydroscope-route-table-private.id
}
# Route Table assosiation private-DB-1
resource "aws_route_table_association" "private-subnet-DB-association-1" {
  subnet_id      = aws_subnet.Private-subnet-3.id
  route_table_id = aws_route_table.hydroscope-route-table-private.id
}

