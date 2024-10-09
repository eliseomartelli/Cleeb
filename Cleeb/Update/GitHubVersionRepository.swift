//
//  GitHubVersionRepository.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 09/10/24.
//

import Foundation

struct GithubVersion: Decodable {
    let name: String
}

enum GithubVersionRepositoryError: Error {
    case noData
    case noVersionFound
}

let GITHUB_API_URL: URL = URL(string: "https://api.github.com/repos/")!

struct GithubVersionRepository {
    static let shared = GithubVersionRepository()
    
    func getVersion(completion: @escaping (Result<String, any Error>) -> Void) {
        URLSession.shared.dataTask(with: getReleasesUrl(repoUrl: "eliseomartelli/Cleeb")) {
            data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard data != nil else {
                completion(.failure(GithubVersionRepositoryError.noData))
                return
            }
            
            do {
                let versions = try JSONDecoder().decode([GithubVersion].self, from: data!)
                guard let latestVersion = versions.first else {
                    completion(.failure(GithubVersionRepositoryError.noVersionFound))
                    return
                }
                completion(.success(latestVersion.name))
                return
            } catch {
                completion(.failure(error))
                return
            }
        }.resume()
    }
    
    // Obtains the repo URL endpoint for releases.
    private func getReleasesUrl(repoUrl : String) -> URL {
        return GITHUB_API_URL
            .appendingPathComponent(repoUrl)
            .appendingPathComponent("releases")
    }
}
