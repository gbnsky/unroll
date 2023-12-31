//
//  Movies.swift
//  Unroll
//
//  Created by Gabriel Garcia on 11/09/23.
//

struct Movies: Codable {
    let page: Int
    let results: [Movie]
}

struct Movie: Codable {
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let originalTitle: String?
    let originalLanguage: String?
    let runtime: Int?
    let tagline: String?
}
