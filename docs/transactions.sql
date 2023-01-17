-- Get task blocks
BEGIN;
SELECT "text","code","language","image_url" FROM task_blocks
    LEFT JOIN task_block_texts tbt on task_blocks.id = tbt.block_id
    LEFT JOIN task_block_codes tbc on task_blocks.id = tbc.block_id
    LEFT JOIN task_block_images tbi on task_blocks.id = tbi.block_id
WHERE task_id = 6
ORDER BY "order";
COMMIT;

-- Add new task
BEGIN;
WITH task AS (INSERT INTO tasks (answer) VALUES ('ans') RETURNING id),
block1 AS (INSERT INTO task_blocks (task_id, "order") VALUES ((SELECT id FROM task), 0) RETURNING id),
block2 AS (INSERT INTO task_blocks (task_id, "order") VALUES ((SELECT id FROM task), 1) RETURNING id),
block3 AS (INSERT INTO task_blocks (task_id, "order") VALUES ((SELECT id FROM task), 2) RETURNING id),
_ AS (INSERT INTO task_block_texts (block_id, text) VALUES ((SELECT id from block1), 'В результате выполнения программы')),
__ AS (INSERT INTO task_block_texts (block_id, text) VALUES ((SELECT id from block3), 'На экран будет выведено'))
INSERT INTO task_block_codes (block_id, code, language) VALUES ((SELECT id from block2), 'printf("ans")', 'c');
COMMIT;

-- Create course
BEGIN;
WITH course AS (INSERT INTO courses ("name") VALUES ('3 Курс ПИ') RETURNING id),
_ AS (INSERT INTO course_teachers (user_email, course_id) VALUES (
    (SELECT "email" FROM users LIMIT 1),
    (SELECT "id" FROM course))
)
INSERT INTO course_students (user_email, course_id) VALUES (
    (SELECT "email" FROM users  OFFSET 1 LIMIT 1),
    (SELECT "id" FROM course)
);
COMMIT;

-- Create test
BEGIN;
WITH test AS (
    INSERT INTO tests (name, owner_email) VALUES ('Тест для ПИ 3 курс', (SELECT "email" FROM users LIMIT 1))
    RETURNING id
)
INSERT INTO test_tasks (test_id, task_id, score, "order") VALUES (
    (SELECT "id" from test),
    (SELECT "id" FROM tasks LIMIT 1),
    10,
    0
);
COMMIT;