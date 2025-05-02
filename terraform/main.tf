provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "n8n_key" {
  key_name   = "n8n-key"
  public_key = file("~/Documents/exercicio_rafa/mateus_nova_chave.pub")
}

resource "aws_security_group" "n8n_sg" {
  name        = "n8n-sg"
  description = "Liberar SSH e porta do n8n"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Em produção, limite por IP
  }

  ingress {
    description = "n8n UI"
    from_port   = 5678
    to_port     = 5678
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ajuste para seu IP se necessário
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "n8n_server" {
  ami                    = "ami-084568db4383264d4" # Ubuntu 24.04 LTS (Região us-east-1)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.n8n_key.key_name
  vpc_security_group_ids = [aws_security_group.n8n_sg.id]

  tags = {
    Name = "n8n-t2micro"
  }
}

resource "aws_eip" "n8n_eip" {
  instance = aws_instance.n8n_server.id
  domain   = "vpc"

  tags = {
    Name = "n8n-eip"
  }
}

output "n8n_public_ip" {
  value       = aws_instance.n8n_server.public_ip
  description = "Endereço IP público da instância n8n"
}
