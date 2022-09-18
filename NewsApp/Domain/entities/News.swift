//
//  News.swift
//  NewsApp
//
//  Created by DG on 18/09/2022.
//

import Foundation

struct News : Codable
{
    var page : Int
    var articales : [Articale]
    
    static func newsFromResponse(response:NewsapiResponse) -> News
    {
        let articles =   response.articles.map({ responseArticle in
            Articale(author: responseArticle.author, title: responseArticle.title, articleDescription: responseArticle.articleDescription, url: responseArticle.url, urlToImage: responseArticle.urlToImage, publishedAt: responseArticle.publishedAt, content: responseArticle.content,providerName: "NewsApi")
        })
        
        return News(page: 0, articales:articles)
    }
    
   static func newsFromResponse(response:NewsDataResponse) -> News
    {
        let articles =   response.results.map({ responseArticle in
            Articale(author: responseArticle.creator?[0], title: responseArticle.title, articleDescription: responseArticle.resultDescription, url: nil, urlToImage: responseArticle.imageURL, publishedAt: responseArticle.pubDate, content: responseArticle.content,providerName: "NewsDataApi")

        })
        return News(page: response.nextPage ?? 0, articales: articles)
    }
}

struct Articale : Codable
{
    let author, title, articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    let providerName : String?
}
