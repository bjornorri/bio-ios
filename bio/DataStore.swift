//
//  DataStore.swift
//  
//
//  Created by Bjorn Orri Saemundsson on 20/02/2018.
//

import Foundation
import Kingfisher
import RxSwift
import RxCocoa

class DataStore {

    static let shared = DataStore()

    let showtimesUpdatedNotification = NSNotification.Name("showtimesUpdated")
    let upcomingUpdatedNotification = NSNotification.Name("upcomingUpdated")

    let showtimes = BehaviorRelay<[Movie]?>(value: nil)
    let upcoming = BehaviorRelay<[Movie]?>(value: nil)
    let loadingShowtimes = BehaviorRelay<Bool>(value: false)
    let loadingUpcoming = BehaviorRelay<Bool>(value: false)

    private init() {
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil) { _ in
            self.fetchData()
        }
    }

    func fetchShowtimes() {
        loadingShowtimes.accept(true)
        Api.getShowtimes { movies in
            self.cacheImages(forMovies: movies)
            self.showtimes.accept(movies)
            self.loadingShowtimes.accept(false)
        }
    }

    func fetchUpcoming() {
        loadingUpcoming.accept(true)
        Api.getUpcoming { movies in
            self.cacheImages(forMovies: movies)
            self.upcoming.accept(movies)
            self.loadingUpcoming.accept(false)
        }
    }

    func fetchData() {
        fetchShowtimes()
        fetchUpcoming()
    }

    func requestNotification(forMovie movie: Movie) {
        Api.createNotification(withDeviceId: getDeviceId(), imdbId: movie.imdbId) { movies in
            self.upcoming.accept(movies)
        }
    }

    func deleteNotification(forMovie movie: Movie) {
        Api.deleteNotification(withDeviceId: getDeviceId(), imdbId: movie.imdbId) { movies in
            self.upcoming.accept(movies)
        }
    }

    private func cacheImages(forMovies movies: [Movie]) {
        for movie in movies {
            if let poster = movie.poster {
                KingfisherManager.shared.retrieveImage(with: poster, options: nil, progressBlock: nil, completionHandler: nil)
            }
            if let backdrop = movie.backdrop {
                KingfisherManager.shared.retrieveImage(with: backdrop, options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }
}
