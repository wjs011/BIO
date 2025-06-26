-- Create the animal_tracking table if it doesn't exist
CREATE TABLE IF NOT EXISTS animal_tracking (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    species VARCHAR(100) NOT NULL,
    species_id VARCHAR(100) NOT NULL,
    animal_id VARCHAR(100) NOT NULL,
    timestamp DATETIME NOT NULL,
    location VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 6) NOT NULL,
    longitude DECIMAL(10, 6) NOT NULL,
    INDEX idx_species_id (species, species_id),
    INDEX idx_animal_id (species, animal_id),
    INDEX idx_timestamp (timestamp)
);

-- Sample data for testing
INSERT INTO animal_tracking (species, species_id, animal_id, timestamp, location, latitude, longitude)
VALUES 
    -- Siberian Tiger tracking - Tiger 1
    ('SiberianTiger', 'ST001', 'Tiger001', '2023-01-01 08:00:00', 'Northeast China Forest', 48.123456, 127.654321),
    ('SiberianTiger', 'ST001', 'Tiger001', '2023-01-01 12:30:00', 'Northeast China Forest', 48.234567, 127.765432),
    ('SiberianTiger', 'ST001', 'Tiger001', '2023-01-01 18:45:00', 'Northeast China Forest', 48.345678, 127.876543),
    ('SiberianTiger', 'ST001', 'Tiger001', '2023-01-02 07:15:00', 'Northeast China Forest', 48.456789, 127.987654),
    ('SiberianTiger', 'ST001', 'Tiger001', '2023-01-02 16:20:00', 'Northeast China Forest', 48.567890, 128.098765),
    
    -- Siberian Tiger tracking - Tiger 2
    ('SiberianTiger', 'ST001', 'Tiger002', '2023-01-01 09:00:00', 'Northeast China Forest', 48.323456, 127.454321),
    ('SiberianTiger', 'ST001', 'Tiger002', '2023-01-01 14:30:00', 'Northeast China Forest', 48.334567, 127.565432),
    ('SiberianTiger', 'ST001', 'Tiger002', '2023-01-01 19:45:00', 'Northeast China Forest', 48.345678, 127.676543),
    ('SiberianTiger', 'ST001', 'Tiger002', '2023-01-02 08:15:00', 'Northeast China Forest', 48.356789, 127.787654),
    ('SiberianTiger', 'ST001', 'Tiger002', '2023-01-02 17:20:00', 'Northeast China Forest', 48.367890, 127.898765),
    
    -- Giant Panda tracking - Panda 1
    ('GiantPanda', 'GP001', 'Panda001', '2023-02-01 09:00:00', 'Sichuan Bamboo Forest', 30.123456, 103.654321),
    ('GiantPanda', 'GP001', 'Panda001', '2023-02-01 14:30:00', 'Sichuan Bamboo Forest', 30.134567, 103.765432),
    ('GiantPanda', 'GP001', 'Panda001', '2023-02-01 19:15:00', 'Sichuan Bamboo Forest', 30.145678, 103.776543),
    ('GiantPanda', 'GP001', 'Panda001', '2023-02-02 08:45:00', 'Sichuan Bamboo Forest', 30.156789, 103.787654),
    ('GiantPanda', 'GP001', 'Panda001', '2023-02-02 15:30:00', 'Sichuan Bamboo Forest', 30.167890, 103.798765),
    
    -- Giant Panda tracking - Panda 2
    ('GiantPanda', 'GP001', 'Panda002', '2023-02-01 10:00:00', 'Sichuan Bamboo Forest', 30.223456, 103.854321),
    ('GiantPanda', 'GP001', 'Panda002', '2023-02-01 15:30:00', 'Sichuan Bamboo Forest', 30.234567, 103.865432),
    ('GiantPanda', 'GP001', 'Panda002', '2023-02-01 20:15:00', 'Sichuan Bamboo Forest', 30.245678, 103.876543),
    ('GiantPanda', 'GP001', 'Panda002', '2023-02-02 09:45:00', 'Sichuan Bamboo Forest', 30.256789, 103.887654),
    ('GiantPanda', 'GP001', 'Panda002', '2023-02-02 16:30:00', 'Sichuan Bamboo Forest', 30.267890, 103.898765),
    
    -- South China Tiger tracking - SCTiger 1
    ('SouthChinaTiger', 'SCT001', 'SCTiger001', '2023-03-01 07:30:00', 'South China Mountain Range', 25.123456, 110.654321),
    ('SouthChinaTiger', 'SCT001', 'SCTiger001', '2023-03-01 13:15:00', 'South China Mountain Range', 25.234567, 110.765432),
    ('SouthChinaTiger', 'SCT001', 'SCTiger001', '2023-03-01 19:00:00', 'South China Mountain Range', 25.345678, 110.876543),
    ('SouthChinaTiger', 'SCT001', 'SCTiger001', '2023-03-02 08:30:00', 'South China Mountain Range', 25.456789, 110.987654),
    ('SouthChinaTiger', 'SCT001', 'SCTiger001', '2023-03-02 16:45:00', 'South China Mountain Range', 25.567890, 111.098765),
    
    -- South China Tiger tracking - SCTiger 2
    ('SouthChinaTiger', 'SCT001', 'SCTiger002', '2023-03-01 08:30:00', 'South China Mountain Range', 25.623456, 110.754321),
    ('SouthChinaTiger', 'SCT001', 'SCTiger002', '2023-03-01 14:15:00', 'South China Mountain Range', 25.634567, 110.865432),
    ('SouthChinaTiger', 'SCT001', 'SCTiger002', '2023-03-01 20:00:00', 'South China Mountain Range', 25.645678, 110.976543),
    ('SouthChinaTiger', 'SCT001', 'SCTiger002', '2023-03-02 09:30:00', 'South China Mountain Range', 25.656789, 111.087654),
    ('SouthChinaTiger', 'SCT001', 'SCTiger002', '2023-03-02 17:45:00', 'South China Mountain Range', 25.667890, 111.198765); 