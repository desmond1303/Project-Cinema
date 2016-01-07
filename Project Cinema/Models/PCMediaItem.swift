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
    struct ProductionCompany {
        var name: String
        var id: Int
    }*/
    
    dynamic var itemType:String = "" // Movie or TV
    dynamic var backdropPath: String = ""
    var genres = List<PCMediaItemGenre>()
    dynamic var homepage: String = ""
    dynamic var itemId: Int = 0
    dynamic var originalLanguage: String = ""
    dynamic var originalTitle: String = ""
    dynamic var overview: String = ""
    dynamic var popularity: Double = 0
    dynamic var posterPath: String = ""
    //var productionCompanies = [ProductionCompany]()
    dynamic var status: String = ""
    dynamic var title: String = "" // "name" for tv
    dynamic var voteAverage: Double = 0
    dynamic var voteCount: Int = 0
    dynamic var rating: Int = 0
    
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
    dynamic var belongsToCollection: Int = 0
    dynamic var budget: Int = 0
    dynamic var imdbId: Int = 0
    //var production_countries = [ProductionCountry]()
    dynamic var releaseDate: String = ""
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
    */
    //var created_by = [Creator]()
    dynamic var episodeRunTime: PCMediaItemEpisodeRuntime? = PCMediaItemEpisodeRuntime()
    dynamic var firstAirDate: String = ""
    dynamic var inProduction: Bool = false
    //dynamic var languages = [String]()
    dynamic var lastAirDate: String = ""
    //var networks = [Network]()
    dynamic var numberOfEpisodes: Int = 0
    dynamic var numberOfSeasons: Int = 0
    //dynamic var origin_country = [String]()
    var seasons = List<PCMediaItemSeason>()
    dynamic var type: String = ""
    
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    convenience init(object: PCMediaItem) {
        self.init()
        
        self.title = object.title
        self.itemType = object.itemType
        self.backdropPath = object.backdropPath
        self.genres = object.genres
        self.homepage = object.homepage
        self.itemId  = object.itemId
        self.originalLanguage = object.originalLanguage
        self.originalTitle = object.originalTitle
        self.overview = object.overview
        self.popularity = object.popularity
        self.posterPath = object.posterPath
        //self.productionCompanies = object.productionCompanies
        self.status = object.status
        self.voteAverage = object.voteAverage
        self.voteCount = object.voteCount
        self.rating = object.rating
        
        self.adult = object.adult
        self.belongsToCollection = object.belongsToCollection
        self.budget = object.budget
        self.imdbId = object.imdbId
        //self.productionCountries = object.productionCountries
        self.releaseDate = object.releaseDate
        self.revenue = object.revenue
        self.runtime = object.runtime
        //self.spokenLanguages = object.spokenLanguages
        self.tagline = object.tagline
        self.video = object.video
        
        self.episodeRunTime = object.episodeRunTime
        self.firstAirDate = object.firstAirDate
        self.inProduction = object.inProduction
        //self.languages = object.languages
        self.lastAirDate = object.lastAirDate
        //self.networks = object.networks
        self.numberOfEpisodes = object.numberOfEpisodes
        self.numberOfSeasons = object.numberOfSeasons
        //self.originCountry = object.originCountry
        self.seasons = object.seasons
        self.type = object.type
    }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.itemType = self.title != "" ? "movie" : "tv"
        self.title <- map["name"]
        self.backdropPath <- map["backdrop_path"]
        
        var genresRaw = [PCMediaItemGenre]()
        genresRaw <- map["genres"]
        self.genres.appendContentsOf(genresRaw)
        
        self.homepage <- map["homepage"]
        self.itemId  <- map["id"]
        self.originalLanguage <- map["original_language"]
        self.originalTitle <- map["original_title"]
        self.overview <- map["overview"]
        self.popularity <- map["popularity"]
        self.posterPath <- map["poster_path"]
        //self.productionCompanies <- map["production_companies"]
        self.status <- map["status"]
        self.voteAverage <- map["vote_average"]
        self.voteCount <- map["vote_count"]
        self.rating <- map["rating"]
        
        self.adult <- map["adult"]
        self.belongsToCollection <- map["belongs_to_collection"]
        self.budget <- map["budget"]
        self.imdbId <- map["imdb_id"]
        //self.productionCountries <- map["production_countries"]
        self.releaseDate <- map["release_date"]
        self.revenue <- map["revenue"]
        self.runtime <- map["runtime"]
        //self.spokenLanguages <- map["spoken_languages"]
        self.tagline <- map["tagline"]
        self.video <- map["video"]
        
        var episodeRuntimeRaw = [Int]()
        episodeRuntimeRaw <- map["episode_run_time"]
        if episodeRuntimeRaw.count > 0 {
            self.episodeRunTime = PCMediaItemEpisodeRuntime()
            self.episodeRunTime?.timeMin = episodeRuntimeRaw[0]
            self.episodeRunTime?.timeMax = episodeRuntimeRaw[1]
        }
        
        self.firstAirDate <- map["first_air_date"]
        self.inProduction <- map["in_production"]
        //self.languages <- map["languages"]
        self.lastAirDate <- map["last_air_date"]
        //self.networks <- map["networks"]
        self.numberOfEpisodes <- map["number_of_episodes"]
        self.numberOfSeasons <- map["number_of_seasons"]
        //self.originCountry <- map["origin_country"]
        
        var seasonsRaw = [PCMediaItemSeason]()
        seasonsRaw <- map["seasons"]
        self.seasons.appendContentsOf(seasonsRaw)
        
        self.type <- map["type"]
    }
    
    override class func primaryKey() -> String {
        return "itemId"
    }
    
}

class PCMediaItemCrew: Object, Mappable {
    dynamic var department: String = ""
    dynamic var job: String = ""
    dynamic var name: String = ""
    dynamic var crewId:Int = 0
    dynamic var profilePath: String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.department <- map["department"]
        self.job <- map["job"]
        self.name <- map["name"]
        self.crewId <- map["id"]
        self.profilePath <- map["profile_path"]
        
    }
}

class PCMediaItemCast: Object, Mappable {
    
    dynamic var actorId: Int = 0
    dynamic var creditId: Int = 0
    dynamic var name: String = ""
    dynamic var character: String = ""
    dynamic var profilePath: String = ""
    
    //dynamic var crew = [PCMediaItemCrew]()
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.actorId <- map["id"]
        self.creditId <- map["credit_id"]
        self.name <- map["name"]
        self.character <- map["character"]
        self.profilePath <- map["profile_path"]
        
    }
    
}

class PCMediaItemGenre: Object, Mappable {
    
    dynamic var id: Int = 0
    dynamic var name: String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    convenience init(object: PCMediaItemGenre) {
        self.init()
        
        self.id = object.id
        self.name = object.name
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
}

class PCMediaItemSeason: Object, Mappable {
    
    dynamic var id: Int = 0
    dynamic var seasonNumber: String = ""
    dynamic var airDate: String = ""
    dynamic var episodeCount: Int = 0
    dynamic var posterPath: String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    convenience init(object: PCMediaItemSeason) {
        self.init()
        
        self.id = object.id
        self.seasonNumber = object.seasonNumber
        self.airDate = object.airDate
        self.episodeCount = object.episodeCount
        self.posterPath = object.posterPath
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.seasonNumber <- map["season_number"]
        self.airDate <- map["air_date"]
        self.episodeCount <- map["episode_count"]
        self.posterPath <- map["poster_path"]
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
}

class PCMediaItemEpisodeRuntime: Object {
    
    dynamic var timeMin: Int = 0
    dynamic var timeMax: Int = 0
    
}