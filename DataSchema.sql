CREATE TABLE exercises (
    exercise_id INTEGER,
    exercise_name VARCHAR(50) NOT NULL,
    difficulty_level VARCHAR(20) NOT NULL,
    duration_sec REAL NOT NULL,
    tolerance_deg REAL NOT NULL,
    CONSTRAINT exercises_pk PRIMARY KEY (exercise_id),
    CONSTRAINT exercises_name_uq UNIQUE (exercise_name),
    CONSTRAINT exercises_name_ck CHECK (
        LENGTH(exercise_name) BETWEEN 3 AND 50
        AND exercise_name REGEXP
        '^[A-Za-zА-Яа-яІіЇїЄєҐґ]+([- ][A-Za-zА-Яа-яІіЇїЄєҐґ]+)*$'
    ),
    CONSTRAINT exercises_level_ck CHECK (
        difficulty_level REGEXP '^(початковий|середній)$'
    ),
    CONSTRAINT exercises_duration_ck CHECK (duration_sec > 0),
    CONSTRAINT exercises_tolerance_ck CHECK (tolerance_deg > 0)
);

CREATE TABLE reference_points (
    reference_point_id INTEGER,
    exercise_id INTEGER NOT NULL,
    time_sec REAL NOT NULL,
    reference_angle_deg REAL NOT NULL,
    CONSTRAINT reference_points_pk PRIMARY KEY (reference_point_id),
    CONSTRAINT reference_points_exercise_fk FOREIGN KEY (exercise_id)
    REFERENCES exercises (exercise_id),
    CONSTRAINT reference_points_time_ck CHECK (time_sec >= 0),
    CONSTRAINT reference_points_angle_ck CHECK (
        reference_angle_deg BETWEEN -540 AND 540
    )
);

CREATE TABLE attempts (
    attempt_id INTEGER,
    exercise_id INTEGER NOT NULL,
    start_timestamp TIMESTAMP NOT NULL,
    zero_position_deg REAL NOT NULL,
    CONSTRAINT attempts_pk PRIMARY KEY (attempt_id),
    CONSTRAINT attempts_exercise_fk FOREIGN KEY (exercise_id)
    REFERENCES exercises (exercise_id),
    CONSTRAINT attempts_zero_ck CHECK (
        zero_position_deg BETWEEN -180 AND 180
    )
);

CREATE TABLE measurements (
    measurement_id INTEGER,
    attempt_id INTEGER NOT NULL,
    time_sec REAL NOT NULL,
    angle_deg REAL NOT NULL,
    CONSTRAINT measurements_pk PRIMARY KEY (measurement_id),
    CONSTRAINT measurements_attempt_fk FOREIGN KEY (attempt_id)
    REFERENCES attempts (attempt_id),
    CONSTRAINT measurements_time_ck CHECK (time_sec >= 0),
    CONSTRAINT measurements_angle_ck CHECK (angle_deg BETWEEN -540 AND 540)
);

CREATE TABLE scores (
    score_id INTEGER,
    attempt_id INTEGER NOT NULL,
    accuracy_deg REAL NOT NULL,
    smoothness_degps REAL NOT NULL,
    CONSTRAINT scores_pk PRIMARY KEY (score_id),
    CONSTRAINT scores_attempt_fk FOREIGN KEY (attempt_id)
    REFERENCES attempts (attempt_id),
    CONSTRAINT scores_attempt_uq UNIQUE (attempt_id),
    CONSTRAINT scores_accuracy_ck CHECK (accuracy_deg >= 0),
    CONSTRAINT scores_smoothness_ck CHECK (smoothness_degps >= 0)
);
