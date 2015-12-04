//
//  PCMediaItem.swift
//  Project Cinema
//
//  Created by Dino Praso on 21.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class PCMediaItem: Object, Mappable {
    
    // Universal
    
    /*
    struct Genre {
        var id: Int
        var name: String
    }
    
    struct ProductionCompany {
        var name: String
        var id: Int
    }*/
    
    dynamic var itemType:String = "" // Movie or TV
    
    dynamic var backdropPath: String = ""
    /*var genresArray = [Genre]() {
        didSet {
            self.genres = String(genresArray)
        }
    }*/
    dynamic var genres: String = ""
    dynamic var homepage: String = ""
    dynamic var itemId: Int = 0
    dynamic var original_language: String = ""
    dynamic var original_title: String = ""
    dynamic var overview: String = ""
    dynamic var popularity: Double = 0
    dynamic var posterPath: String = ""
    //var productionCompanies = [ProductionCompany]()
    dynamic var status: String = ""
    dynamic var title: String = "" // "name" for tv
    dynamic var voteAverage: Double = 0
    dynamic var voteCount: Int = 0
    
    //var cast
    
    
    // Movie Only
    /*
    struct ProductionCountry {
        var iso_3166_1: String
        var name: String
    }
    
    struct SpokenLanguage {
        var iso_639_1: String
        var name: String
    }*/
    
    dynamic var adult: Bool = false
    dynamic var belongs_to_collection: Int = 0
    dynamic var budget: Int = 0
    dynamic var imdb_id: Int = 0
    //var production_countries = [ProductionCountry]()
    dynamic var release_date: String = ""
    dynamic var revenue: Int = 0
    dynamic var runtime: Int = 0
    //var spoken_languages = [SpokenLanguage]()
    dynamic var tagline: String = ""
    dynamic var video: Bool = false
    
    
    // TV Only
    /*
    struct Creator {
        var id: Int
        var name: String
        var profile_path: String
    }
    
    struct Network {
        var id: Int
        var name: String
    }
    
    struct Season {
        var air_date: String
        var episode_count: Int
        var id: Int
        var poster_path: String
        var season_number: Int
    }
    */
    //var created_by = [Creator]()
    //dynamic var episode_run_time = [Int]()
    dynamic var first_air_date: String = ""
    dynamic var in_production: Bool = false
    //dynamic var languages = [String]()
    dynamic var last_air_date: String = ""
    //var networks = [Network]()
    dynamic var number_of_episodes: Int = 0
    dynamic var number_of_seasons: Int = 0
    //dynamic var origin_country = [String]()
    //var seasons = [Season]()
    dynamic var type: String = ""
    
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    convenience init(object: PCMediaItem) {
        self.init()
        
        self.title = object.title
        self.itemType = object.itemType
        //self.test = object.production_companies
        
        self.backdropPath = object.backdropPath
        //self.genresArray = object.genres
        //self.genres: String =  ""
        self.homepage = object.homepage
        self.itemId  = object.itemId
        self.original_language = object.original_language
        self.original_title = object.original_title
        self.overview = object.overview
        self.popularity = object.popularity
        self.posterPath = object.posterPath
        //self.productionCompanies = object.production_companies
        self.status = object.status
        self.voteAverage = object.voteAverage
        self.voteCount = object.voteCount
        
        self.adult = object.adult
        self.belongs_to_collection = object.belongs_to_collection
        self.budget = object.budget
        self.imdb_id = object.imdb_id
        //self.production_countries =  [ProductionCountry]()
        self.release_date = object.release_date
        self.revenue = object.revenue
        self.runtime = object.runtime
        //self.spoken_languages = [SpokenLanguage]()
        self.tagline = object.tagline
        self.video = object.video
        
        self.first_air_date = object.first_air_date
        self.in_production = object.in_production
        //self.languages = [String]()
        self.last_air_date = object.last_air_date
        //self.networks = [Network]()
        self.number_of_episodes = object.number_of_episodes
        self.number_of_seasons = object.number_of_seasons
        //self.origin_country = [String]()
        //self.seasons = [Season]()
        self.type = object.type
    }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.itemType = self.title != "" ? "movie" : "tv"
        self.title <- map["name"]
        //self.test <- map["production_companies"]
        
        self.backdropPath <- map["backdrop_path"]
        //self.genresArray <- map["genres"]
        //self.genres: String = ""
        self.homepage <- map["homepage"]
        self.itemId  <- map["id"]
        self.original_language <- map["original_language"]
        self.original_title <- map["original_title"]
        self.overview <- map["overview"]
        self.popularity <- map["popularity"]
        self.posterPath <- map["poster_path"]
        //self.productionCompanies <- map["production_companies"]
        self.status <- map["status"]
        self.voteAverage <- map["vote_average"]
        self.voteCount <- map["vote_count"]
        
        self.adult <- map["adult"]
        self.belongs_to_collection <- map["belongs_to_collection"]
        self.budget <- map["budget"]
        self.imdb_id <- map["imdb_id"]
        //self.production_countries = [ProductionCountry]()
        self.release_date <- map["release_date"]
        self.revenue <- map["revenue"]
        self.runtime <- map["runtime"]
        //self.spoken_languages = [SpokenLanguage]()
        self.tagline <- map["tagline"]
        self.video <- map["video"]
        
        self.first_air_date <- map["first_air_date"]
        self.in_production <- map["in_production"]
        //self.languages <- map["languages"]
        self.last_air_date <- map["last_air_date"]
        //self.networks = [Network]()
        self.number_of_episodes <- map["number_of_episodes"]
        self.number_of_seasons <- map["number_of_seasons"]
        //self.origin_country = [String]()
        //self.seasons = [Season]()
        self.type <- map["type"]
    }
    
    override class func primaryKey() -> String {
        return "itemId"
    }
    
}