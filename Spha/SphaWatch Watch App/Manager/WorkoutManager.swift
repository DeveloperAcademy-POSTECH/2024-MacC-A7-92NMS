//
//  WorkoutManager.swift
//  SphaWatch Watch App
//
//  Created by LDW on 12/3/24.
//

import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    private var healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?

    func startWorkout() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data is not available.")
            return
        }

        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .mindAndBody // 명상 관련 활동
        workoutConfiguration.locationType = .unknown

        do {
            // 워크아웃 세션 및 빌더 생성
            session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            builder = session?.associatedWorkoutBuilder()

            // 세션과 빌더의 델리게이트 설정
            session?.delegate = self
            builder?.delegate = self

            // 데이터 소스 설정
            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutConfiguration)

            // 세션 시작
            session?.startActivity(with: Date())
            builder?.beginCollection(withStart: Date(), completion: { success, error in
                if let error = error {
                    print("Error starting workout collection: \(error.localizedDescription)")
                }
            })

            print("Workout session started.")
        } catch {
            print("Error creating workout session: \(error.localizedDescription)")
        }
    }

    func stopWorkout() {
        session?.end()
        print("Workout session ended.")
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            print("Workout session running.")
        case .ended:
            print("Workout session ended.")
        default:
            break
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed: \(error.localizedDescription)")
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        print("Workout event collected.")
    }
}
