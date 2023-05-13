https://whimsical.com/school-app-71CTekXgeAobKRZ9ZKvaki
https://hexdocs.pm/ecto/associations.html
https://hexdocs.pm/ecto/crud.html
https://hexdocs.pm/ecto/constraints-and-upserts.html

# SchoolApp / Entities
  # District (name)
  # School (name, district)
  # Course (name)
  # Segment (name)
  # Course_Segment (course, segment)
  # School_Course (school, course)
  # Job (name)
  # Teacher (name, job, school)
  # Class (code)
  # Grade (name)
  # Class_Grade (class, grade)
  # Class_Teacher (class, teacher)
  # Student (name, avatar, code, class, grade)
  # Domain (name)
  # Goal (name, domain)
  # Student_Domain(student, domain)
  # Assessment (moment, student, class, grade, domain, goal, value)


# SchoolApp / Divis�o dos trabalhos

Designer                              => Mariana/Roger
Web designer                          => Mariana/Roger
Analista de negócios                  => Mariana
Analista de sistemas                  => Roger
Arquiteto de software                 => Roger
Desenvolvedor/Programador             => Roger
Analista de banco de dados            => Roger
Analistas de testes (QA)              => Mariana
Gerente de projetos ou coordenador    => Mariana
Suporte                               => Phyerre/Adriana

mix phx.new school_app
mix phx.gen.live Schools School schools name:string
mix ecto.gen.migration create_district
