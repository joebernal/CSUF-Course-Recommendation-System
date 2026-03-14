USE tuffyplan;

-- =========================================================
-- Ensure base major + catalog year exist
-- =========================================================
INSERT INTO catalog_years (catalog_name, start_term, start_year)
SELECT 'Fall 2025 & Beyond', 'Fall', 2025
WHERE NOT EXISTS (
    SELECT 1 FROM catalog_years WHERE catalog_name = 'Fall 2025 & Beyond'
);

INSERT INTO majors (major_name, major_acronym)
SELECT 'Computer Science', 'CS'
WHERE NOT EXISTS (
    SELECT 1 FROM majors WHERE major_acronym = 'CS'
);

-- =========================================================
-- COURSES
-- =========================================================
INSERT INTO courses
(course_code, course_name, course_description, units_min, units_max, has_lab, includes_lab)
VALUES
('CPSC 120A', 'Introduction to Programming Lecture',
 'Introduction computer science and computer programming, including designing programs; sequential execution; variables, assignment and arithmetic; control flow, Boolean logic, selection and loops; input/output; functions; debugging; practical applications; and development methodologies.',
 2, 2, FALSE, FALSE),

('CPSC 120L', 'Introduction to Programming Lab',
 'Introduction to computer science and computer programming, including designing programs; sequential execution; variables, assignment and arithmetic; control flow, Boolean logic, selection and loops; input/output; functions; debugging; practical applications; and development methodologies.',
 1, 1, TRUE, FALSE),

('CPSC 121A', 'Object Oriented Programming Lecture',
 'The object-oriented programming paradigm, including classes, objects, member variables and functions; exceptions, inheritance, templates, encapsulation, decoupling and class design best practices. Advanced program design, including iterators, operator overloading, recursion and dynamic memory allocation.',
 2, 2, FALSE, FALSE),

('CPSC 121L', 'Object-Oriented Programming Lab',
 'Apply object-oriented programming concepts, including classes, objects, member variables and functions; exceptions, inheritance, templates, encapsulation, decoupling and class design best practices. Advanced program design, including iterators, operator overloading, recursion and dynamic memory allocation.',
 1, 1, TRUE, FALSE),

('CPSC 131', 'Data Structures',
 'Classical data structures: vector, linked list, stack, queue, binary search tree, and graph representations. Worst-case analysis, amortized analysis, and big-O notation. Object-oriented and recursive implementation of data structures. Self-resizing vectors and self-balancing trees. Empirical performance measurement.',
 3, 3, FALSE, FALSE),

('CPSC 223C', 'C Programming',
 'Systems programming in the C language, including its syntax and semantics; essential idioms; important parts of the C11 and POSIX C APIs; security issues; and notable extensions libraries.',
 3, 3, FALSE, FALSE),

('CPSC 223J', 'Java Programming',
 'Characteristics of Java: portable, robust, secure, object-oriented, high performance; using the Java environment; server administration; types, expressions and control flow; classes, interfaces and packages; threads; exceptions; class libraries; Java for the Internet; tools, the Java virtual machine.',
 3, 3, FALSE, FALSE),

('CPSC 223N', 'Visual C# Programming',
 'Characteristics of C#, object-oriented design concepts, control structures, methods, arrays, classes, objects, inheritance, polymorphism, exception handling, graphical user interfaces, multithreading, characters, strings, files, streams. Rudiments of the Unified Modeling Language. Software development assignments.',
 3, 3, FALSE, FALSE),

('CPSC 223P', 'Python Programming',
 'Concepts of computing, domain-specific problem solving with computing technologies. Methodologies, tools and the application development process. Variables, expressions, control flow, functions, standard libraries, packages, data structures, files, modularization, integration. Develop functional applications.',
 3, 3, FALSE, FALSE),

('CPSC 223W', 'Swift Programming',
 'Introduction to Swift, a programming language primarily used to develop software for Apple operating systems. Introduces skills to learn a new programming language.',
 3, 3, FALSE, FALSE),

('CPSC 240', 'Computer Organization and Assembly Language',
 'Digital logic and architecture of a computer system, machine level representation of data, memory system organization, structure of low-level computer languages. Machine, assembly, and macro language programming. Principles of assembler operation, input-output programming, interrupt/exception handling. Laboratory programming assignments.',
 3, 3, FALSE, FALSE),

('CPSC 253', 'Cybersecurity Foundations and Principles',
 'Security goals, security systems, access controls, networks and security, integrity, cryptography fundamentals, authentication. Attacks: software, network, website; management considerations, security standards in government and industry; security issues in requirements, architecture, design, implementation, testing, operation, maintenance, acquisition and services.',
 3, 3, FALSE, FALSE),

('CPSC 315', 'Professional Ethics in Computing',
 'Ethics and moral philosophy as applied to software and digital artifacts. Notions of rights, responsibilities, property, ownership, privacy, security, and professional ethics. Security obligations. Intellectual property statutes, licenses, and their terms. Oral and written reports are required.',
 3, 3, FALSE, FALSE),

('CPSC 323', 'Compilers and Languages',
 'Basic concepts of programming languages and principles of translation. Topics include history of programming languages, various programming paradigms, language design issues and criteria, design of compilers for modern programming languages.',
 3, 3, FALSE, FALSE),

('CPSC 332', 'File Structures and Database Systems',
 'Fundamental theories and design of database systems, the Structured Query Language (SQL), basic concepts and techniques of data organization in secondary storage. Topics include introduction to database systems, ER model, relational model, index structures and hashing techniques.',
 3, 3, FALSE, FALSE),

('CPSC 335', 'Algorithm Engineering',
 'Algorithm design using classical patterns: exhaustive search, divide and conquer, randomization, hashing, reduction, dynamic programming, and the greedy method. Asymptotic and experimental efficiency analysis. NP-completeness and decidability. Implementing algorithms to solve practical problems.',
 3, 3, FALSE, FALSE),

('CPSC 351', 'Operating Systems Concepts',
 'Resource management, memory organization, input/output, control process synchronization and other concepts as related to the objectives of multi-user operating systems.',
 3, 3, FALSE, FALSE),

('CPSC 362', 'Foundations of Software Engineering',
 'Basic concepts, principles, methods, techniques and practices of software engineering. All aspects of the software engineering fields. Use Computer-Aided Software Engineering (CASE) tools.',
 3, 3, FALSE, FALSE),

('CPSC 471', 'Computer Communications',
 'Introduction to digital data communications. Terminology, networks and their components, common-carrier services, telecommunication facilities, terminals, error control, multiplexing and concentration techniques.',
 3, 3, FALSE, FALSE),

('CPSC 481', 'Artificial Intelligence',
 'Using computers to simulate human intelligence. Production systems, pattern recognition, problem solving, searching game trees, knowledge representation and logical reasoning. Programming in AI environments.',
 3, 3, FALSE, FALSE),

('CPSC 490', 'Undergraduate Seminar in Computer Science',
 'Review of foundational computer science theories and principles, real-world application development methods and processes, and industry practices. Survey of modern computing technologies. Research methods. Identification of research or practical application problems. Writing and presenting a proposal for a capstone project.',
 3, 3, FALSE, FALSE),

('CPSC 491', 'Senior Capstone Project in Computer Science',
 'A computer science research or real-world level of application development project. Business communication. Presenting the results to a wide range of audiences. Demonstrating the culminating experience of the practicum in computer science. Writing a final project report and technical documents such as user manuals, installation guides, feasibility study reports.',
 3, 3, FALSE, FALSE),

('MATH 150A', 'Calculus I',
 'Properties of functions. The limit, derivative and definite integral concepts; applications of the derivative, techniques and applications of integration.',
 4, 4, FALSE, FALSE),

('MATH 150B', 'Calculus II',
 'Techniques of integration, improper integrals and applications of integration. Introduction to differential equations. Parametric equations, sequences and series.',
 4, 4, FALSE, FALSE),

('MATH 170A', 'Mathematical Structures I',
 'First of two semesters of fundamental discrete mathematical concepts and techniques needed in computer-related disciplines. Logic, truth tables, elementary set theory, proof techniques, combinatorics, Boolean algebra, recursion and graph theory.',
 3, 3, FALSE, FALSE),

('MATH 170B', 'Mathematical Structures II',
 'Second of two semesters of fundamental discrete mathematical concepts and techniques needed in computer-related disciplines, focusing on linear algebra.',
 3, 3, FALSE, FALSE),

('MATH 338', 'Statistics Applied to Natural Sciences',
 'Introduction to the theory and application of statistics. Elementary probability, estimation, hypothesis testing, regression, variance analysis, non-parametric tests. Computer-aided analysis of real data. Graphical techniques, generating and interpreting statistical output, presentation of analysis.',
 4, 4, FALSE, FALSE),

('BIOL 101', 'Elements of Biology',
 'Underlying principles governing life forms, processes and interactions. Elements of biology and reasoning skills for understanding scientific issues on personal, societal and global levels. For non-science majors.',
 3, 3, FALSE, FALSE),

('BIOL 101L', 'Elements of Biology Laboratory',
 'Laboratory experiments demonstrating principles from the lecture course. Scientific inquiry, cells, physiology, genetics, biodiversity, evolution and ecology.',
 1, 1, TRUE, FALSE),

('BIOL 151', 'Cellular and Molecular Biology',
 'Lecture and laboratory exploration of eukaryotic/prokaryotic cellular structure and function, biological molecules, classical/Mendelian genetics, regulation of gene expression and biotechnology, cell signaling, metabolic pathways, the process and regulation of cellular reproduction, evolution of multicellularity.',
 4, 4, FALSE, TRUE),

('BIOL 152', 'Evolution and Organismal Biology',
 'Introduction to evolution and organismal biology. Evolutionary processes that resulted in the biodiversity of life on Earth. Physiological processes and ecological challenges for organisms.',
 4, 4, FALSE, TRUE),

('CHEM 120A', 'General Chemistry',
 'The principles of chemistry: stoichiometry, acids, bases, redox reactions, gas laws, solid and liquid states, changes of state, modern atomic concepts, periodicity and chemical bonding. Laboratory: elementary syntheses, spectroscopy and volumetric quantitative analysis.',
 5, 5, FALSE, TRUE),

('CHEM 120B', 'General Chemistry',
 'Chemical thermodynamics, chemical equilibrium, elementary electrochemistry and chemical kinetics. Laboratory: quantitative and qualitative analysis and elementary physical chemistry.',
 5, 5, FALSE, TRUE),

('CHEM 123', 'Chemistry for Engineers',
 'Fundamental concepts of chemistry for engineering students. Atomic structure, periodic table, stoichiometry, states of matter, chemical bonding, new materials, solutions, thermodynamics, reaction rates, equilibrium, electrochemistry, polymers and nuclear reactions.',
 3, 3, FALSE, FALSE),

('CHEM 125', 'General Chemistry B Lecture',
 'For students who do not need a second semester of general chemistry lab. Chemical thermodynamics, chemical equilibrium, elementary electrochemistry and chemical kinetics.',
 3, 3, FALSE, FALSE),

('GEOL 101', 'Introduction to Geology',
 'Introduction to the science of rocks, fossils, volcanoes, earthquakes, landscapes and oceans. Natural hazards, geology in everyday life and geology as field of practice.',
 3, 3, FALSE, FALSE),

('GEOL 101L', 'Introduction to Geology Laboratory',
 'Hands-on analysis and evaluation of rocks, maps, geologic time and Earth processes. Natural hazards, geology in everyday life and scientific inquiry.',
 1, 1, TRUE, FALSE),

('GEOL 201', 'Earth History',
 'Evolution of Earth as interpreted from rocks, fossils and geologic structures. Plate tectonics provides a unifying theme for consideration of mountain building, evolution of life and ancient environments.',
 3, 3, FALSE, TRUE),

('GEOL 201L', 'Earth History Supplemental Lab',
 'Supervised research on topics related to Earth history. Project will result in a term paper and/or web page.',
 1, 1, TRUE, FALSE),

('MATH 250A', 'Calculus III',
 'Calculus of functions of several variables. Partial derivatives and multiple integrals with applications. Parametric curves, vector-valued functions, vector fields, line integrals, Green’s Theorem, Stokes’ theorem, the Divergence Theorem, vectors and the geometry of 3-space.',
 4, 4, FALSE, FALSE),

('MATH 250B', 'Introduction to Linear Algebra and Differential Equations',
 'Introduction to the solutions of ordinary differential equations and their relationship to linear algebra. Topics include matrix algebra, systems of linear equations, vector spaces, linear independence, linear transformations and eigenvalues.',
 4, 4, FALSE, FALSE),

('PHYS 225', 'Fundamental Physics: Mechanics',
 'Classical Newtonian mechanics; linear and circular motion; energy; linear/angular momentum; systems of particles; rigid body motion; wave motion and sound.',
 3, 3, FALSE, FALSE),

('PHYS 225L', 'Fundamental Physics: Laboratory',
 'Laboratory for PHYS 225.',
 1, 1, TRUE, FALSE),

('PHYS 226', 'Fundamental Physics: Electricity and Magnetism',
 'Electrostatics, electric potential, capacitance, dielectrics, electrical circuits, resistance, emf, electromagnetic induction, magnetism and magnetic materials, and introduction to Maxwell’s equations.',
 3, 3, FALSE, FALSE),

('PHYS 226L', 'Fundamental Physics: Laboratory',
 'Laboratory for PHYS 226.',
 1, 1, TRUE, FALSE),

('PHYS 227', 'Fundamental Physics: Waves, Optics, and Modern Physics',
 'Geometrical and physical optics, wave phenomena; quantum physics, including the photoelectric effect, line spectra and the Bohr atom; the wave nature of matter, Schroedinger’s equation and solutions; the Uncertainty Principle, special theory of relativity.',
 1, 3, FALSE, FALSE),

('PHYS 227L', 'Fundamental Physics: Laboratory',
 'Laboratory for PHYS 227.',
 1, 1, TRUE, FALSE),

('CPSC 254', 'Applied Artificial Intelligence',
 'Concepts of Artificial Intelligence, application software and open-source projects. Understanding AI capabilities, AI applications, their impact and ethical issues. Identifying domain-specific problems and solving them with AI technologies and related open-source projects.',
 3, 3, FALSE, FALSE),

('CPSC 301', 'Programming Lab Practicum',
 'Intensive programming covering concepts learned in lower-division courses. Procedural and object oriented design, documentation, arrays, classes, file input/output, recursion, pointers, dynamic variables, data and file structures.',
 2, 2, FALSE, FALSE),

('CPSC 349', 'Web Front-End Engineering',
 'Concepts and architecture of interactive web applications, including markup, stylesheets and behavior. Functional and object-oriented aspects of JavaScript. Model-view design patterns, templates and frameworks. Client-side technologies for asynchronous events, real-time interaction and access to back-end web services.',
 3, 3, FALSE, FALSE),

('CPSC 352', 'Cryptography',
 'Introduction to cryptography and steganography. Encryption, cryptographic hashing, certificates, and signatures. Classical, symmetric-key, and public-key ciphers. Block modes of operation. Cryptanalysis including exhaustive search, man-in-the-middle, and birthday attacks. Programming projects involving implementation of cryptographic systems.',
 3, 3, FALSE, FALSE),

('CPSC 375', 'Introduction to Data Science and Big Data',
 'Techniques for data preparation, exploratory analysis, statistical modeling, machine learning and visualization. Methods for analyzing different types of data, such as natural language and time-series, from emerging applications, including Internet-of-Things. Big data platforms. Projects with real-world data.',
 3, 3, FALSE, FALSE),

('CPSC 386', 'Introduction to Game Design and Production',
 'Current and future technologies and market trends in game design and production. Game technologies, basic building tools for games and the process of game design, development and production.',
 3, 3, FALSE, FALSE),

('CPSC 411', 'Mobile Device Application Programming',
 'Introduction to developing applications for mobile devices, including but not limited to runtime environments, development tools and debugging tools used in creating applications for mobile devices. Use emulators in lab.',
 3, 3, FALSE, FALSE),

('CPSC 411A', 'Mobile Device Application Programming for Android',
 'Introduction to developing applications for Android mobile devices, including but not limited to runtime environments, development tools and debugging tools used in creating applications for mobile devices. Use emulators in lab.',
 3, 3, FALSE, FALSE),

('CPSC 431', 'Database and Applications',
 'Database design and application development techniques for a real world system. System analysis, requirement specifications, conceptual modeling, logic design, physical design and web interface development. Develop projects using contemporary database management system and web-based application development platform.',
 3, 3, FALSE, FALSE),

('CPSC 439', 'Theory of Computation',
 'Introduction to the theory of computation. Automata theory; finite state machines, context free grammars, and Turing machines; hierarchy of formal language classes. Computability theory and undecidable problems. Time complexity; P and NP-complete problems. Applications to software design and security.',
 3, 3, FALSE, FALSE),

('CPSC 440', 'Computer System Architecture',
 'Computer performance, price/performance, instruction set design and examples. Processor design, pipelining, memory hierarchy design and input/output subsystems.',
 3, 3, FALSE, FALSE),

('CPSC 449', 'Web Back-End Engineering',
 'Design and architecture of large-scale web applications. Techniques for scalability, session management and load balancing. Dependency injection, application tiers, message queues, web services and REST architecture. Caching and eventual consistency. Data models, partitioning and replication in relational and non-relational databases.',
 3, 3, FALSE, FALSE),

('CPSC 454', 'Cloud Computing and Security',
 'Cloud computing and cloud security, distributed computing, computer clusters, grid computing, virtual machines and virtualization, cloud computing platforms and deployment models, cloud programming and software environments, vulnerabilities and risks of cloud computing, cloud infrastructure protection, data privacy and protection.',
 3, 3, FALSE, FALSE),

('CPSC 455', 'Web Security',
 'Concepts of web application security. Web security mechanisms, including authentication, access control and protecting sensitive data. Common vulnerabilities, including code and SQL attacks, cross-site scripting and cross-site request forgery. Implement hands-on web application security mechanisms and security testing.',
 3, 3, FALSE, FALSE),

('CPSC 456', 'Network Security Fundamentals',
 'Learn about vulnerabilities of network protocols, attacks targeting confidentiality, integrity and availability of data transmitted across networks, and methods for diagnosing and closing security gaps through hands-on exercises.',
 3, 3, FALSE, FALSE),

('CPSC 458', 'Malware Analysis',
 'Introduction to principles and practices of malware analysis. Topics include static and dynamic code analysis, data decoding, analysis tools, debugging, shellcode analysis, reverse engineering of stealthy malware and written presentation of analysis results.',
 3, 3, FALSE, FALSE),

('CPSC 459', 'Blockchain Technologies',
 'Digital assets as a medium of exchange to secure financial transactions; decentralized and distributed ledgers that record verifiable transactions; smart contracts and Ethereum; Bitcoin mechanics and mining; the cryptocurrency ecosystem; blockchain mechanics and applications.',
 3, 3, FALSE, FALSE),

('CPSC 462', 'Software Design',
 'Concepts of software modeling, software process and some tools. Object-oriented analysis and design and Unified process. Some computer-aided software engineering (CASE) tools will be recommended to use for doing homework assignments.',
 3, 3, FALSE, FALSE),

('CPSC 463', 'Software Testing',
 'Software testing techniques, reporting problems effectively and planning testing projects. Students apply what they learned throughout the course to a sample application that is either commercially available or under development.',
 3, 3, FALSE, FALSE),

('CPSC 464', 'Software Architecture',
 'Basic principles and practices of software design and architecture. High-level design, software architecture, documenting software architecture, software and architecture evaluation, software product lines and some considerations beyond software architecture.',
 3, 3, FALSE, FALSE),

('CPSC 466', 'Software Process',
 'Practical guidance for improving the software development process. How to establish, maintain and improve software processes. Exposure to agile processes, ISO 12207 and CMMI.',
 3, 3, FALSE, FALSE),

('CPSC 474', 'Parallel and Distributed Computing',
 'Concepts of distributed computing; distributed memory and shared memory architectures; parallel programming techniques; inter-process communication and synchronization; programming for parallel architectures such as multi-core and GPU platforms; project involving distributed application development.',
 3, 3, FALSE, FALSE),

('CPSC 479', 'Introduction to High Performance Computing',
 'Introduction to the concepts of high-performance computing and the paradigms of parallel programming in a high level programming language, design and implementation of parallel algorithms on distributed memory, machine learning techniques on large data sets, implementation of parallel algorithms.',
 3, 3, FALSE, FALSE),

('CPSC 483', 'Introduction to Machine Learning',
 'Design, implement and analyze machine learning algorithms, including supervised learning and unsupervised learning algorithms. Methods to address uncertainty. Projects with real-world data.',
 3, 3, FALSE, FALSE),

('CPSC 484', 'Principles of Computer Graphics',
 'Examine and analyze computer graphics, software structures, display processor organization, graphical input/output devices, display files. Algorithmic techniques for clipping, windowing, character generation and viewpoint transformation.',
 3, 3, FALSE, FALSE),

('CPSC 485', 'Computational Bioinformatics',
 'Algorithmic approaches to biological problems. Specific topics include motif finding, genome rearrangement, DNA sequence comparison, sequence alignment, DNA sequencing, repeat finding and gene expression analysis.',
 3, 3, FALSE, FALSE),

('CPSC 486', 'Game Programming',
 'Survey of data structures and algorithms used for real-time rendering and computer game programming. Build upon existing mathematics and programming knowledge to create interactive graphics programs.',
 3, 3, FALSE, FALSE),

('CPSC 499', 'Independent Study',
 'Special topic in computer science, selected in consultation with and completed under the supervision of instructor. Requires approval by the Computer Science chair.',
 1, 3, FALSE, FALSE),

('EGGN 495', 'Professional Practice',
 'Professional engineering work in industry or government. Written report required.',
 1, 3, FALSE, FALSE),

('MATH 335', 'Mathematical Probability',
 'Probability theory; discrete, continuous and multivariate probability distributions, independence, conditional probability distribution, expectation, moment generating functions, functions of random variables and the central limit theorem.',
 4, 4, FALSE, FALSE),

('MATH 340', 'Numerical Analysis',
 'Approximate numerical solutions of systems of linear and nonlinear equations, interpolation theory, numerical differentiation and integration, numerical solution of ordinary differential equations. Computer coding of numerical methods.',
 4, 4, FALSE, FALSE),

('MATH 370', 'Mathematical Model Building',
 'Introduction to mathematical models in science and engineering. Dimensional analysis, discrete and continuous dynamical systems, and numerous other topics. Emphasizes deriving equations and using mathematical tools to make predictions.',
 4, 4, FALSE, FALSE),

('HONR 201B', 'Honors Seminar: American Institutions and Values since 1877',
 'Honors Seminar: American Institutions and Values since 1877.',
 3, 3, FALSE, FALSE),

('POSC 100', 'American Government',
 'People, their politics, and power; contemporary issues, changing political styles and processes, institution and underlying values of the American political system. Satisfies state requirements in U.S. Constitution and California State and local government.',
 3, 3, FALSE, FALSE)
ON DUPLICATE KEY UPDATE
course_name = VALUES(course_name),
course_description = VALUES(course_description),
units_min = VALUES(units_min),
units_max = VALUES(units_max),
has_lab = VALUES(has_lab),
includes_lab = VALUES(includes_lab);

-- =========================================================
-- COURSE PAIRS
-- =========================================================
INSERT INTO course_pairs (course_id, paired_course_id, pair_type)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1, courses c2
WHERE c1.course_code = 'CPSC 120A'
  AND c2.course_code = 'CPSC 120L'
  AND NOT EXISTS (
      SELECT 1 FROM course_pairs cp
      WHERE cp.course_id = c1.id AND cp.paired_course_id = c2.id AND cp.pair_type = 'lecture_lab'
  );

INSERT INTO course_pairs (course_id, paired_course_id, pair_type)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1, courses c2
WHERE c1.course_code = 'CPSC 121A'
  AND c2.course_code = 'CPSC 121L'
  AND NOT EXISTS (
      SELECT 1 FROM course_pairs cp
      WHERE cp.course_id = c1.id AND cp.paired_course_id = c2.id AND cp.pair_type = 'lecture_lab'
  );

INSERT INTO course_pairs (course_id, paired_course_id, pair_type)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1, courses c2
WHERE c1.course_code = 'BIOL 101'
  AND c2.course_code = 'BIOL 101L'
  AND NOT EXISTS (
      SELECT 1 FROM course_pairs cp
      WHERE cp.course_id = c1.id AND cp.paired_course_id = c2.id AND cp.pair_type = 'lecture_lab'
  );

INSERT INTO course_pairs (course_id, paired_course_id, pair_type)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1, courses c2
WHERE c1.course_code = 'GEOL 101'
  AND c2.course_code = 'GEOL 101L'
  AND NOT EXISTS (
      SELECT 1 FROM course_pairs cp
      WHERE cp.course_id = c1.id AND cp.paired_course_id = c2.id AND cp.pair_type = 'lecture_lab'
  );

INSERT INTO course_pairs (course_id, paired_course_id, pair_type)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1, courses c2
WHERE c1.course_code = 'GEOL 201'
  AND c2.course_code = 'GEOL 201L'
  AND NOT EXISTS (
      SELECT 1 FROM course_pairs cp
      WHERE cp.course_id = c1.id AND cp.paired_course_id = c2.id AND cp.pair_type = 'lecture_lab'
  );

INSERT INTO course_pairs (course_id, paired_course_id, pair_type)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1, courses c2
WHERE c1.course_code = 'PHYS 225'
  AND c2.course_code = 'PHYS 225L'
  AND NOT EXISTS (
      SELECT 1 FROM course_pairs cp
      WHERE cp.course_id = c1.id AND cp.paired_course_id = c2.id AND cp.pair_type = 'lecture_lab'
  );

INSERT INTO course_pairs (course_id, paired_course_id, pair_type)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1, courses c2
WHERE c1.course_code = 'PHYS 226'
  AND c2.course_code = 'PHYS 226L'
  AND NOT EXISTS (
      SELECT 1 FROM course_pairs cp
      WHERE cp.course_id = c1.id AND cp.paired_course_id = c2.id AND cp.pair_type = 'lecture_lab'
  );

INSERT INTO course_pairs (course_id, paired_course_id, pair_type)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1, courses c2
WHERE c1.course_code = 'PHYS 227'
  AND c2.course_code = 'PHYS 227L'
  AND NOT EXISTS (
      SELECT 1 FROM course_pairs cp
      WHERE cp.course_id = c1.id AND cp.paired_course_id = c2.id AND cp.pair_type = 'lecture_lab'
  );

-- =========================================================
-- MAJOR REQUIREMENTS
-- =========================================================
INSERT INTO major_requirements
(major_id, catalog_year_id, requirement_name, requirement_type, required_units_min, required_units_max, note)
SELECT
    m.id,
    cy.id,
    'Lower-Division Core',
    'core',
    18,
    18,
    'Computer Science Core lower-division requirement'
FROM majors m
JOIN catalog_years cy ON cy.catalog_name = 'Fall 2025 & Beyond'
WHERE m.major_acronym = 'CS'
AND NOT EXISTS (
    SELECT 1
    FROM major_requirements mr
    WHERE mr.major_id = m.id
      AND mr.catalog_year_id = cy.id
      AND mr.requirement_name = 'Lower-Division Core'
);

INSERT INTO major_requirements
(major_id, catalog_year_id, requirement_name, requirement_type, required_units_min, required_units_max, note)
SELECT
    m.id,
    cy.id,
    'Upper-Division Core',
    'core',
    30,
    30,
    'Computer Science Core upper-division requirement'
FROM majors m
JOIN catalog_years cy ON cy.catalog_name = 'Fall 2025 & Beyond'
WHERE m.major_acronym = 'CS'
AND NOT EXISTS (
    SELECT 1
    FROM major_requirements mr
    WHERE mr.major_id = m.id
      AND mr.catalog_year_id = cy.id
      AND mr.requirement_name = 'Upper-Division Core'
);

INSERT INTO major_requirements
(major_id, catalog_year_id, requirement_name, requirement_type, required_units_min, required_units_max, note)
SELECT
    m.id,
    cy.id,
    'Mathematics Requirements',
    'math',
    18,
    18,
    'Mathematics requirements for Computer Science'
FROM majors m
JOIN catalog_years cy ON cy.catalog_name = 'Fall 2025 & Beyond'
WHERE m.major_acronym = 'CS'
AND NOT EXISTS (
    SELECT 1
    FROM major_requirements mr
    WHERE mr.major_id = m.id
      AND mr.catalog_year_id = cy.id
      AND mr.requirement_name = 'Mathematics Requirements'
);

INSERT INTO major_requirements
(major_id, catalog_year_id, requirement_name, requirement_type, required_units_min, required_units_max, note)
SELECT
    m.id,
    cy.id,
    'Science and Mathematics Electives',
    'science_elective',
    12,
    12,
    'Choose courses from the approved science and mathematics elective list'
FROM majors m
JOIN catalog_years cy ON cy.catalog_name = 'Fall 2025 & Beyond'
WHERE m.major_acronym = 'CS'
AND NOT EXISTS (
    SELECT 1
    FROM major_requirements mr
    WHERE mr.major_id = m.id
      AND mr.catalog_year_id = cy.id
      AND mr.requirement_name = 'Science and Mathematics Electives'
);

INSERT INTO major_requirements
(major_id, catalog_year_id, requirement_name, requirement_type, required_units_min, required_units_max, note)
SELECT
    m.id,
    cy.id,
    'Computer Science Electives',
    'cs_elective',
    15,
    15,
    'Computer Science electives; maximum 3 lower-division elective units may be selected'
FROM majors m
JOIN catalog_years cy ON cy.catalog_name = 'Fall 2025 & Beyond'
WHERE m.major_acronym = 'CS'
AND NOT EXISTS (
    SELECT 1
    FROM major_requirements mr
    WHERE mr.major_id = m.id
      AND mr.catalog_year_id = cy.id
      AND mr.requirement_name = 'Computer Science Electives'
);

INSERT INTO major_requirements
(major_id, catalog_year_id, requirement_name, requirement_type, required_units_min, required_units_max, note)
SELECT
    m.id,
    cy.id,
    'Graduation Requirement',
    'graduation',
    3,
    3,
    'American Institutions / graduation requirement'
FROM majors m
JOIN catalog_years cy ON cy.catalog_name = 'Fall 2025 & Beyond'
WHERE m.major_acronym = 'CS'
AND NOT EXISTS (
    SELECT 1
    FROM major_requirements mr
    WHERE mr.major_id = m.id
      AND mr.catalog_year_id = cy.id
      AND mr.requirement_name = 'Graduation Requirement'
);

INSERT INTO major_requirements
(major_id, catalog_year_id, requirement_name, requirement_type, required_units_min, required_units_max, note)
SELECT
    m.id,
    cy.id,
    'General Education',
    'ge',
    24,
    24,
    'Students should take approved GE courses for Computer Science majors listed in Titan Degree Audit'
FROM majors m
JOIN catalog_years cy ON cy.catalog_name = 'Fall 2025 & Beyond'
WHERE m.major_acronym = 'CS'
AND NOT EXISTS (
    SELECT 1
    FROM major_requirements mr
    WHERE mr.major_id = m.id
      AND mr.catalog_year_id = cy.id
      AND mr.requirement_name = 'General Education'
);

-- =========================================================
-- MAJOR REQUIREMENT COURSES
-- =========================================================

-- Lower-Division Core required courses
INSERT INTO major_requirement_courses (major_requirement_id, course_id, choice_group, note)
SELECT mr.id, c.id, 0, 'Required lower-division core course'
FROM major_requirements mr
JOIN courses c
WHERE mr.requirement_name = 'Lower-Division Core'
AND c.course_code IN (
    'CPSC 120A','CPSC 120L','CPSC 121A','CPSC 121L','CPSC 131','CPSC 240','CPSC 253'
)
AND NOT EXISTS (
    SELECT 1
    FROM major_requirement_courses mrc
    WHERE mrc.major_requirement_id = mr.id
      AND mrc.course_id = c.id
);

-- Lower-Division Core language choice (choose one)
INSERT INTO major_requirement_courses (major_requirement_id, course_id, choice_group, note)
SELECT mr.id, c.id, 1, 'Choose one programming language course'
FROM major_requirements mr
JOIN courses c
WHERE mr.requirement_name = 'Lower-Division Core'
AND c.course_code IN ('CPSC 223C','CPSC 223J','CPSC 223N','CPSC 223P','CPSC 223W')
AND NOT EXISTS (
    SELECT 1
    FROM major_requirement_courses mrc
    WHERE mrc.major_requirement_id = mr.id
      AND mrc.course_id = c.id
);

-- Upper-Division Core required courses
INSERT INTO major_requirement_courses (major_requirement_id, course_id, choice_group, note)
SELECT mr.id, c.id, 0, 'Required upper-division core course'
FROM major_requirements mr
JOIN courses c
WHERE mr.requirement_name = 'Upper-Division Core'
AND c.course_code IN (
    'CPSC 315','CPSC 323','CPSC 332','CPSC 335','CPSC 351',
    'CPSC 362','CPSC 471','CPSC 481','CPSC 490','CPSC 491'
)
AND NOT EXISTS (
    SELECT 1
    FROM major_requirement_courses mrc
    WHERE mrc.major_requirement_id = mr.id
      AND mrc.course_id = c.id
);

-- Math requirements required courses
INSERT INTO major_requirement_courses (major_requirement_id, course_id, choice_group, note)
SELECT mr.id, c.id, 0, 'Required math course'
FROM major_requirements mr
JOIN courses c
WHERE mr.requirement_name = 'Mathematics Requirements'
AND c.course_code IN ('MATH 150A','MATH 150B','MATH 170A','MATH 170B','MATH 338')
AND NOT EXISTS (
    SELECT 1
    FROM major_requirement_courses mrc
    WHERE mrc.major_requirement_id = mr.id
      AND mrc.course_id = c.id
);

-- Science and Mathematics Electives
INSERT INTO major_requirement_courses (major_requirement_id, course_id, choice_group, note)
SELECT mr.id, c.id, 99, 'Approved science/math elective option'
FROM major_requirements mr
JOIN courses c
WHERE mr.requirement_name = 'Science and Mathematics Electives'
AND c.course_code IN (
    'BIOL 101','BIOL 101L','BIOL 151','BIOL 152',
    'CHEM 120A','CHEM 120B','CHEM 123','CHEM 125',
    'GEOL 101','GEOL 101L','GEOL 201','GEOL 201L',
    'MATH 250A','MATH 250B','PHYS 225','PHYS 225L',
    'PHYS 226','PHYS 226L','PHYS 227','PHYS 227L'
)
AND NOT EXISTS (
    SELECT 1
    FROM major_requirement_courses mrc
    WHERE mrc.major_requirement_id = mr.id
      AND mrc.course_id = c.id
);

-- CS Electives
INSERT INTO major_requirement_courses (major_requirement_id, course_id, choice_group, note)
SELECT mr.id, c.id, 99, 'Approved CS elective option'
FROM major_requirements mr
JOIN courses c
WHERE mr.requirement_name = 'Computer Science Electives'
AND c.course_code IN (
    'CPSC 254','CPSC 301','CPSC 349','CPSC 352','CPSC 375',
    'CPSC 386','CPSC 411','CPSC 411A','CPSC 431','CPSC 439',
    'CPSC 440','CPSC 449','CPSC 454','CPSC 455','CPSC 456',
    'CPSC 458','CPSC 459','CPSC 462','CPSC 463','CPSC 464',
    'CPSC 466','CPSC 474','CPSC 479','CPSC 483','CPSC 484',
    'CPSC 485','CPSC 486','CPSC 499','EGGN 495','MATH 335',
    'MATH 340','MATH 370'
)
AND NOT EXISTS (
    SELECT 1
    FROM major_requirement_courses mrc
    WHERE mrc.major_requirement_id = mr.id
      AND mrc.course_id = c.id
);

-- Graduation Requirement (choose one)
INSERT INTO major_requirement_courses (major_requirement_id, course_id, choice_group, note)
SELECT mr.id, c.id, 1, 'Choose one course to satisfy graduation requirement'
FROM major_requirements mr
JOIN courses c
WHERE mr.requirement_name = 'Graduation Requirement'
AND c.course_code IN ('HONR 201B','POSC 100')
AND NOT EXISTS (
    SELECT 1
    FROM major_requirement_courses mrc
    WHERE mrc.major_requirement_id = mr.id
      AND mrc.course_id = c.id
);

-- =========================================================
-- MAJOR RULES
-- =========================================================
INSERT INTO major_rules
(major_id, catalog_year_id, rule_name, rule_value_int, rule_value_text, is_enforced)
SELECT
    m.id,
    cy.id,
    'Max lower-division CS elective units',
    3,
    'A maximum of 3 units of lower-division units may be selected in Computer Science Electives.',
    TRUE
FROM majors m
JOIN catalog_years cy ON cy.catalog_name = 'Fall 2025 & Beyond'
WHERE m.major_acronym = 'CS'
AND NOT EXISTS (
    SELECT 1 FROM major_rules r
    WHERE r.major_id = m.id
      AND r.catalog_year_id = cy.id
      AND r.rule_name = 'Max lower-division CS elective units'
);

-- =========================================================
-- PREREQUISITES / COREQUISITES
-- =========================================================

-- CPSC 120A corequisite: CPSC 120L
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Corequisite: CPSC 120L.'
FROM courses c
WHERE c.course_code = 'CPSC 120A'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'corequisite'
      AND cr.note = 'Corequisite: CPSC 120L.'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'CPSC 120L'
WHERE c.course_code = 'CPSC 120A'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Corequisite: CPSC 120L.'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.required_course_id = rc.id
        AND cri.item_type = 'course'
  );

-- CPSC 120L corequisite: CPSC 120A
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Corequisite: CPSC 120A.'
FROM courses c
WHERE c.course_code = 'CPSC 120L'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'corequisite'
      AND cr.note = 'Corequisite: CPSC 120A.'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'CPSC 120A'
WHERE c.course_code = 'CPSC 120L'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Corequisite: CPSC 120A.'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.required_course_id = rc.id
        AND cri.item_type = 'course'
  );

-- CPSC 121A prerequisite/corequisite
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: CPSC 120; or CPSC 120A and CPSC 120L; or passing score on Computer Science Placement Exam.'
FROM courses c
WHERE c.course_code = 'CPSC 121A'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'prerequisite'
);

SET @req_121A_pre = (
    SELECT cr.id
    FROM course_requirements cr
    JOIN courses c ON c.id = cr.course_id
    WHERE c.course_code = 'CPSC 121A' AND cr.requirement_type = 'prerequisite'
    LIMIT 1
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id, exam_name)
SELECT @req_121A_pre, 1, 'course', c.id, NULL
FROM courses c
WHERE c.course_code = 'CPSC 120A'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_121A_pre
      AND group_number = 1
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id, exam_name)
SELECT @req_121A_pre, 1, 'course', c.id, NULL
FROM courses c
WHERE c.course_code = 'CPSC 120L'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_121A_pre
      AND group_number = 1
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, exam_name)
SELECT @req_121A_pre, 1, 'exam', 'Computer Science Placement Exam'
WHERE NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_121A_pre
      AND group_number = 1
      AND item_type = 'exam'
      AND exam_name = 'Computer Science Placement Exam'
);

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Corequisite: CPSC 121L.'
FROM courses c
WHERE c.course_code = 'CPSC 121A'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'corequisite'
      AND cr.note = 'Corequisite: CPSC 121L.'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'CPSC 121L'
WHERE c.course_code = 'CPSC 121A'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Corequisite: CPSC 121L.'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.required_course_id = rc.id
        AND cri.item_type = 'course'
  );

-- CPSC 121L prerequisite/corequisite
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: CPSC 120; or CPSC 120A and CPSC 120L; or passing score on Computer Science Placement Exam.'
FROM courses c
WHERE c.course_code = 'CPSC 121L'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'prerequisite'
);

SET @req_121L_pre = (
    SELECT cr.id
    FROM course_requirements cr
    JOIN courses c ON c.id = cr.course_id
    WHERE c.course_code = 'CPSC 121L' AND cr.requirement_type = 'prerequisite'
    LIMIT 1
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id, exam_name)
SELECT @req_121L_pre, 1, 'course', c.id, NULL
FROM courses c
WHERE c.course_code = 'CPSC 120A'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_121L_pre
      AND group_number = 1
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id, exam_name)
SELECT @req_121L_pre, 1, 'course', c.id, NULL
FROM courses c
WHERE c.course_code = 'CPSC 120L'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_121L_pre
      AND group_number = 1
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, exam_name)
SELECT @req_121L_pre, 1, 'exam', 'Computer Science Placement Exam'
WHERE NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_121L_pre
      AND group_number = 1
      AND item_type = 'exam'
      AND exam_name = 'Computer Science Placement Exam'
);

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Corequisite: CPSC 121A.'
FROM courses c
WHERE c.course_code = 'CPSC 121L'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'corequisite'
      AND cr.note = 'Corequisite: CPSC 121A.'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'CPSC 121A'
WHERE c.course_code = 'CPSC 121L'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Corequisite: CPSC 121A.'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.required_course_id = rc.id
        AND cri.item_type = 'course'
  );

-- CPSC 131 prerequisite
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: CPSC 121A and CPSC 121L; or CPSC 121; or sufficient score on the Computer Science Placement Exam.'
FROM courses c
WHERE c.course_code = 'CPSC 131'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'prerequisite'
);

SET @req_131_pre = (
    SELECT cr.id
    FROM course_requirements cr
    JOIN courses c ON c.id = cr.course_id
    WHERE c.course_code = 'CPSC 131' AND cr.requirement_type = 'prerequisite'
    LIMIT 1
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_131_pre, 1, 'course', c.id
FROM courses c
WHERE c.course_code IN ('CPSC 121A','CPSC 121L')
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items cri
    WHERE cri.course_requirement_id = @req_131_pre
      AND cri.required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, exam_name)
SELECT @req_131_pre, 1, 'exam', 'Computer Science Placement Exam'
WHERE NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_131_pre
      AND item_type = 'exam'
      AND exam_name = 'Computer Science Placement Exam'
);

-- Simple prerequisites
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: CPSC 131.'
FROM courses c
WHERE c.course_code IN ('CPSC 223C','CPSC 223J','CPSC 223N','CPSC 223W','CPSC 301','CPSC 349','CPSC 411','CPSC 411A','CPSC 485')
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'CPSC 131'
WHERE c.course_code IN ('CPSC 223C','CPSC 223J','CPSC 223N','CPSC 223W','CPSC 301','CPSC 349','CPSC 411','CPSC 411A','CPSC 485')
AND cr.requirement_type = 'prerequisite'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items cri
    WHERE cri.course_requirement_id = cr.id
      AND cri.required_course_id = rc.id
);

-- CPSC 223P prerequisite as text
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: GE Area 1B or 2A.'
FROM courses c
WHERE c.course_code = 'CPSC 223P'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, item_text)
SELECT cr.id, 1, 'text', 'GE Area 1B or 2A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CPSC 223P'
  AND cr.requirement_type = 'prerequisite'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 1B or 2A'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: GE Area 1B or 2A.'
FROM courses c
WHERE c.course_code = 'CPSC 254'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, item_text)
SELECT cr.id, 1, 'text', 'GE Area 1B or 2A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CPSC 254'
  AND cr.requirement_type = 'prerequisite'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 1B or 2A'
  );

-- CPSC 240
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisites: CPSC 131; MATH 170A or MATH 280; or graduate standing.'
FROM courses c
WHERE c.course_code = 'CPSC 240'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

SET @req_240_pre = (
    SELECT cr.id FROM course_requirements cr
    JOIN courses c ON c.id = cr.course_id
    WHERE c.course_code = 'CPSC 240' AND cr.requirement_type = 'prerequisite'
    LIMIT 1
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_240_pre, 1, 'course', c.id
FROM courses c
WHERE c.course_code = 'CPSC 131'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_240_pre
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, item_text)
SELECT @req_240_pre, 2, 'text', 'MATH 170A or MATH 280 or graduate standing'
WHERE NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_240_pre
      AND item_type = 'text'
      AND item_text = 'MATH 170A or MATH 280 or graduate standing'
);

-- CPSC 253 text restriction
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'restriction', 'Prerequisite: Computer Science major/minor or Computer Engineering student.'
FROM courses c
WHERE c.course_code = 'CPSC 253'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'restriction'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, item_text)
SELECT cr.id, 1, 'text', 'Computer Science major/minor or Computer Engineering student'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CPSC 253'
  AND cr.requirement_type = 'restriction'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.item_type = 'text'
        AND cri.item_text = 'Computer Science major/minor or Computer Engineering student'
  );

-- Common upper-division restriction + CPSC 131 prereq
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: CPSC 131.'
FROM courses c
WHERE c.course_code IN ('CPSC 315','CPSC 323','CPSC 332','CPSC 362')
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'CPSC 131'
WHERE c.course_code IN ('CPSC 315','CPSC 323','CPSC 332','CPSC 362')
AND cr.requirement_type = 'prerequisite'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items cri
    WHERE cri.course_requirement_id = cr.id
      AND cri.required_course_id = rc.id
);

-- CPSC 335
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisites: CPSC 131, MATH 170A, MATH 150A.'
FROM courses c
WHERE c.course_code = 'CPSC 335'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

SET @req_cpsc335 = (
    SELECT cr.id
    FROM course_requirements cr
    JOIN courses c ON c.id = cr.course_id
    WHERE c.course_code = 'CPSC 335' AND cr.requirement_type = 'prerequisite'
    LIMIT 1
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_cpsc335, 1, 'course', c.id
FROM courses c
WHERE c.course_code = 'CPSC 131'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_cpsc335
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_cpsc335, 2, 'course', c.id
FROM courses c
WHERE c.course_code = 'MATH 170A'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_cpsc335
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_cpsc335, 3, 'course', c.id
FROM courses c
WHERE c.course_code = 'MATH 150A'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_cpsc335
      AND required_course_id = c.id
);

-- CPSC 351
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: CPSC 131 and CPSC 240; or graduate standing.'
FROM courses c
WHERE c.course_code = 'CPSC 351'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

SET @req_351_pre = (
    SELECT cr.id FROM course_requirements cr
    JOIN courses c ON c.id = cr.course_id
    WHERE c.course_code = 'CPSC 351' AND cr.requirement_type = 'prerequisite'
    LIMIT 1
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_351_pre, 1, 'course', c.id
FROM courses c
WHERE c.course_code = 'CPSC 131'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_351_pre
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_351_pre, 2, 'course', c.id
FROM courses c
WHERE c.course_code = 'CPSC 240'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_351_pre
      AND required_course_id = c.id
);

-- CPSC 471
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: CPSC 351.'
FROM courses c
WHERE c.course_code = 'CPSC 471'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'CPSC 351'
WHERE c.course_code = 'CPSC 471'
AND cr.requirement_type = 'prerequisite'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items cri
    WHERE cri.course_requirement_id = cr.id
      AND cri.required_course_id = rc.id
);

-- CPSC 481
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisites: CPSC 335 and MATH 338.'
FROM courses c
WHERE c.course_code = 'CPSC 481'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

SET @req_481_pre = (
    SELECT cr.id FROM course_requirements cr
    JOIN courses c ON c.id = cr.course_id
    WHERE c.course_code = 'CPSC 481' AND cr.requirement_type = 'prerequisite'
    LIMIT 1
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_481_pre, 1, 'course', c.id
FROM courses c
WHERE c.course_code = 'CPSC 335'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_481_pre
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_481_pre, 2, 'course', c.id
FROM courses c
WHERE c.course_code = 'MATH 338'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_481_pre
      AND required_course_id = c.id
);

-- CPSC 490
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisites: CPSC 362, junior or senior standing, Computer Science major.'
FROM courses c
WHERE c.course_code = 'CPSC 490'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

SET @req_490_pre = (
    SELECT cr.id FROM course_requirements cr
    JOIN courses c ON c.id = cr.course_id
    WHERE c.course_code = 'CPSC 490' AND cr.requirement_type = 'prerequisite'
    LIMIT 1
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_490_pre, 1, 'course', c.id
FROM courses c
WHERE c.course_code = 'CPSC 362'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_490_pre
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, item_text)
SELECT @req_490_pre, 2, 'text', 'Junior or senior standing and Computer Science major'
WHERE NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_490_pre
      AND item_type = 'text'
      AND item_text = 'Junior or senior standing and Computer Science major'
);

-- CPSC 491
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: CPSC 490.'
FROM courses c
WHERE c.course_code = 'CPSC 491'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'CPSC 490'
WHERE c.course_code = 'CPSC 491'
AND cr.requirement_type = 'prerequisite'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items cri
    WHERE cri.course_requirement_id = cr.id
      AND cri.required_course_id = rc.id
);

-- Math prerequisites
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: MATH 150A.'
FROM courses c
WHERE c.course_code = 'MATH 150B'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'MATH 150A'
WHERE c.course_code = 'MATH 150B'
AND cr.requirement_type = 'prerequisite'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items cri
    WHERE cri.course_requirement_id = cr.id
      AND cri.required_course_id = rc.id
);

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: MATH 150B.'
FROM courses c
WHERE c.course_code = 'MATH 338'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'MATH 150B'
WHERE c.course_code = 'MATH 338'
AND cr.requirement_type = 'prerequisite'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items cri
    WHERE cri.course_requirement_id = cr.id
      AND cri.required_course_id = rc.id
);

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: MATH 150B.'
FROM courses c
WHERE c.course_code = 'MATH 250A'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'MATH 150B'
WHERE c.course_code = 'MATH 250A'
AND cr.requirement_type = 'prerequisite'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items cri
    WHERE cri.course_requirement_id = cr.id
      AND cri.required_course_id = rc.id
);

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: MATH 250A.'
FROM courses c
WHERE c.course_code IN ('MATH 250B','MATH 335')
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id AND cr.requirement_type = 'prerequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'MATH 250A'
WHERE c.course_code IN ('MATH 250B','MATH 335')
AND cr.requirement_type = 'prerequisite'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items cri
    WHERE cri.course_requirement_id = cr.id
      AND cri.required_course_id = rc.id
);

-- Physics prerequisites/corequisites
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Corequisites: MATH 150A and PHYS 225L.'
FROM courses c
WHERE c.course_code = 'PHYS 225'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'corequisite'
);

SET @req_phys225 = (
    SELECT cr.id FROM course_requirements cr
    JOIN courses c ON c.id = cr.course_id
    WHERE c.course_code = 'PHYS 225' AND cr.requirement_type = 'corequisite'
    LIMIT 1
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_phys225, 1, 'course', c.id
FROM courses c
WHERE c.course_code = 'MATH 150A'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_phys225
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_phys225, 2, 'course', c.id
FROM courses c
WHERE c.course_code = 'PHYS 225L'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_phys225
      AND required_course_id = c.id
);

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Corequisite: PHYS 225.'
FROM courses c
WHERE c.course_code = 'PHYS 225L'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'corequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'PHYS 225'
WHERE c.course_code = 'PHYS 225L'
  AND cr.requirement_type = 'corequisite'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.required_course_id = rc.id
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: PHYS 225. Corequisites: MATH 150B and PHYS 226L.'
FROM courses c
WHERE c.course_code = 'PHYS 226'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'prerequisite'
);

SET @req_phys226 = (
    SELECT cr.id FROM course_requirements cr
    JOIN courses c ON c.id = cr.course_id
    WHERE c.course_code = 'PHYS 226' AND cr.requirement_type = 'prerequisite'
    LIMIT 1
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_phys226, 1, 'course', c.id
FROM courses c
WHERE c.course_code = 'PHYS 225'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_phys226
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, item_text)
SELECT @req_phys226, 2, 'text', 'Corequisites: MATH 150B and PHYS 226L'
WHERE NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_phys226
      AND item_type = 'text'
      AND item_text = 'Corequisites: MATH 150B and PHYS 226L'
);

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Corequisite: PHYS 226.'
FROM courses c
WHERE c.course_code = 'PHYS 226L'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'corequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'PHYS 226'
WHERE c.course_code = 'PHYS 226L'
  AND cr.requirement_type = 'corequisite'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.required_course_id = rc.id
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'Prerequisite: PHYS 226. Corequisite: PHYS 227L.'
FROM courses c
WHERE c.course_code = 'PHYS 227'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'prerequisite'
);

SET @req_phys227 = (
    SELECT cr.id FROM course_requirements cr
    JOIN courses c ON c.id = cr.course_id
    WHERE c.course_code = 'PHYS 227' AND cr.requirement_type = 'prerequisite'
    LIMIT 1
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT @req_phys227, 1, 'course', c.id
FROM courses c
WHERE c.course_code = 'PHYS 226'
AND NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_phys227
      AND required_course_id = c.id
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, item_text)
SELECT @req_phys227, 2, 'text', 'Corequisite: PHYS 227L'
WHERE NOT EXISTS (
    SELECT 1 FROM course_requirement_items
    WHERE course_requirement_id = @req_phys227
      AND item_type = 'text'
      AND item_text = 'Corequisite: PHYS 227L'
);

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Corequisite: PHYS 227.'
FROM courses c
WHERE c.course_code = 'PHYS 227L'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements cr
    WHERE cr.course_id = c.id
      AND cr.requirement_type = 'corequisite'
);

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', rc.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses rc ON rc.course_code = 'PHYS 227'
WHERE c.course_code = 'PHYS 227L'
  AND cr.requirement_type = 'corequisite'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.required_course_id = rc.id
  );

-- Graduation requirement courses do not need extra prereq logic here