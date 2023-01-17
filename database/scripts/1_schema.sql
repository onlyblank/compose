CREATE TABLE "users" (
  "email" TEXT PRIMARY KEY,
  "password" TEXT NOT NULL,
  "first_name" TEXT NOT NULL,
  "last_name" TEXT
);

CREATE TABLE "tasks" (
  "id" SERIAL PRIMARY KEY,
  "answer" TEXT NOT NULL
);

CREATE TABLE "task_blocks" (
  "id" SERIAL UNIQUE,
  "task_id" INT NOT NULL,
  "order" INT NOT NULL,
  PRIMARY KEY ("task_id", "order")
);

CREATE TABLE "task_block_texts" (
  "id" SERIAL PRIMARY KEY,
  "block_id" INT NOT NULL,
  "text" TEXT NOT NULL
);

CREATE TABLE "task_block_images" (
  "id" SERIAL PRIMARY KEY,
  "block_id" INT NOT NULL,
  "image_url" TEXT NOT NULL
);

CREATE TABLE "task_block_codes" (
  "id" SERIAL PRIMARY KEY,
  "block_id" INT NOT NULL,
  "code" TEXT NOT NULL,
  "language" TEXT
);

CREATE TABLE "courses" (
  "id" SERIAL PRIMARY KEY,
  "name" TEXT NOT NULL
);

CREATE TABLE "course_teachers" (
  "user_email" TEXT,
  "course_id" INT,
  PRIMARY KEY ("user_email", "course_id")
);

CREATE TABLE "course_students" (
  "user_email" TEXT,
  "course_id" INT,
  PRIMARY KEY ("user_email", "course_id")
);

CREATE TABLE "tests" (
  "id" SERIAL PRIMARY KEY,
  "name" TEXT NOT NULL,
  "owner_email" TEXT NOT NULL
);

CREATE TABLE "test_tasks" (
  "test_id" INT NOT NULL,
  "task_id" INT NOT NULL,
  "score" INT NOT NULL,
  "order" INT NOT NULL,
  PRIMARY KEY ("test_id", "task_id", "order")
);

CREATE TABLE "assignments" (
  "id" SERIAL PRIMARY KEY,
  "test_id" INT NOT NULL,
  "course_id" INT NOT NULL,
  "time_limit" INT
);

CREATE TABLE "task_answer" (
  "id" SERIAL PRIMARY KEY,
  "assignment_id" INT NOT NULL,
  "student_email" TEXT NOT NULL,
  "task_id" INT NOT NULL,
  "answer" TEXT NOT NULL
);

ALTER TABLE "task_blocks" ADD FOREIGN KEY ("task_id") REFERENCES "tasks" ("id");

ALTER TABLE "task_block_texts" ADD FOREIGN KEY ("block_id") REFERENCES "task_blocks" ("id");

ALTER TABLE "task_block_images" ADD FOREIGN KEY ("block_id") REFERENCES "task_blocks" ("id");

ALTER TABLE "task_block_codes" ADD FOREIGN KEY ("block_id") REFERENCES "task_blocks" ("id");

ALTER TABLE "course_teachers" ADD FOREIGN KEY ("user_email") REFERENCES "users" ("email");

ALTER TABLE "course_teachers" ADD FOREIGN KEY ("course_id") REFERENCES "courses" ("id");

ALTER TABLE "course_students" ADD FOREIGN KEY ("user_email") REFERENCES "users" ("email");

ALTER TABLE "course_students" ADD FOREIGN KEY ("course_id") REFERENCES "courses" ("id");

ALTER TABLE "tests" ADD FOREIGN KEY ("owner_email") REFERENCES "users" ("email");

ALTER TABLE "test_tasks" ADD FOREIGN KEY ("test_id") REFERENCES "tests" ("id");

ALTER TABLE "test_tasks" ADD FOREIGN KEY ("task_id") REFERENCES "tasks" ("id");

ALTER TABLE "assignments" ADD FOREIGN KEY ("test_id") REFERENCES "tests" ("id");

ALTER TABLE "assignments" ADD FOREIGN KEY ("course_id") REFERENCES "courses" ("id");

ALTER TABLE "task_answer" ADD FOREIGN KEY ("assignment_id") REFERENCES "assignments" ("id");

ALTER TABLE "task_answer" ADD FOREIGN KEY ("student_email") REFERENCES "users" ("email");

ALTER TABLE "task_answer" ADD FOREIGN KEY ("task_id") REFERENCES "tasks" ("id");
