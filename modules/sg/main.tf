########################################
# SG A (peut sortir via NAT)
########################################
resource "aws_security_group" "sg_a" {
  name        = "ec2-a"
  description = "Security group for EC2 A"
  vpc_id      = var.vpc_id

  # A peut sortir (vers Internet via NAT + trafic interne)
  egress {
    description = "Allow all egress (NAT en aval)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# SG B (pas Internet)
########################################
resource "aws_security_group" "sg_b" {
  name        = "ec2-b"
  description = "Security group for EC2 B"
  vpc_id      = var.vpc_id

  # Restreindre la sortie au VPC (facultatif mais recommandé)
  egress {
    description = "Only inside VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr] # <- ajoute vpc_cidr dans variables du module SG
  }
}

########################################
# SG C (pas Internet)
########################################
resource "aws_security_group" "sg_c" {
  name        = "ec2-c"
  description = "Security group for EC2 C"
  vpc_id      = var.vpc_id

  # Restreindre la sortie au VPC (facultatif mais recommandé)
  egress {
    description = "Only inside VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
}

########################################
# Communication interne A <-> B <-> C
# (Exemples d’autorisations minimales — ici on ouvre tout en interne)
########################################

# B -> A
resource "aws_security_group_rule" "allow_a_from_b" {
  type                     = "ingress"
  description              = "Allow all from B to A"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg_a.id
  source_security_group_id = aws_security_group.sg_b.id
}

# C -> B
resource "aws_security_group_rule" "allow_b_from_c" {
  type                     = "ingress"
  description              = "Allow all from C to B"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg_b.id
  source_security_group_id = aws_security_group.sg_c.id
}

# A -> C
resource "aws_security_group_rule" "allow_c_from_a" {
  type                     = "ingress"
  description              = "Allow all from A to C"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg_c.id
  source_security_group_id = aws_security_group.sg_a.id
}

# (Optionnel) si tu veux vraiment A <-> B, B <-> C, C <-> A dans les deux sens,
# ajoute les règles symétriques ci-dessous :

# A -> B
resource "aws_security_group_rule" "allow_b_from_a" {
  type                     = "ingress"
  description              = "Allow all from A to B"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg_b.id
  source_security_group_id = aws_security_group.sg_a.id
}

# B -> C
resource "aws_security_group_rule" "allow_c_from_b" {
  type                     = "ingress"
  description              = "Allow all from B to C"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg_c.id
  source_security_group_id = aws_security_group.sg_b.id
}

# C -> A
resource "aws_security_group_rule" "allow_a_from_c" {
  type                     = "ingress"
  description              = "Allow all from C to A"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg_a.id
  source_security_group_id = aws_security_group.sg_c.id
}