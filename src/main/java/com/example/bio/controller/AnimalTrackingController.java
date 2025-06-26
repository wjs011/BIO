package com.example.bio.controller;

import com.example.bio.entity.AnimalTracking;
import com.example.bio.repository.AnimalTrackingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/tracking")
public class AnimalTrackingController {

    @Autowired
    private AnimalTrackingRepository animalTrackingRepository;

    @GetMapping("/species/{species}/id/{speciesId}")
    public ResponseEntity<List<AnimalTracking>> getTrackingData(
            @PathVariable String species, @PathVariable String speciesId) {
        List<AnimalTracking> trackingData = animalTrackingRepository
                .findBySpeciesAndSpeciesIdOrderByTimestampAsc(species, speciesId);
        return ResponseEntity.ok(trackingData);
    }

    @GetMapping("/species/{species}/id/{speciesId}/animal/{animalId}")
    public ResponseEntity<List<AnimalTracking>> getTrackingDataByAnimal(
            @PathVariable String species,
            @PathVariable String speciesId,
            @PathVariable String animalId) {
        List<AnimalTracking> trackingData = animalTrackingRepository
                .findBySpeciesAndSpeciesIdAndAnimalIdOrderByTimestampAsc(species, speciesId, animalId);
        return ResponseEntity.ok(trackingData);
    }

    @GetMapping("/all")
    public ResponseEntity<List<AnimalTracking>> getAllTrackingData() {
        List<AnimalTracking> allData = animalTrackingRepository.findAll();
        return ResponseEntity.ok(allData);
    }
}