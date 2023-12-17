//
// Created by Matthew Demers on 12/5/23.
//

import Foundation



struct FilterState{
  var order: Order = .relevance
  var orderDirection: OrderDirection = .desc
  var title: String = ""
  var year: Int?
  var includedTags: [Tag]? = []
  var excludeTags: [Tag]? = []
  var status: [Status]? = []
  var publicationDemographic: [PublicationDemographic]? = []
  var contentRating: [ContentRating]? = []
}