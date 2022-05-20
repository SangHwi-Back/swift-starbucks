import Foundation
enum ProtocolError: Error {
  case noData
  case noResponse
  case urlError
  case bodyError
  case handlerError
}
