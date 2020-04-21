//
//  ContactDetails.swift
//  Time Lines Shared
//
//  Created by Mathieu Dutour on 07/04/2020.
//  Copyright © 2020 Mathieu Dutour. All rights reserved.
//

import SwiftUI

struct Main: View {
  @ObservedObject var contact: Contact
  @ObservedObject var currentTime = CurrentTime.shared

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        Text(contact.name ?? "No Name")
          .font(.title)
        Spacer()
        Text(contact.timeZone?.prettyPrintTimeDiff() ?? "")
          .font(.title)
      }

      HStack(alignment: .top) {
        Text(contact.locationName ?? "No location")
          .font(.subheadline)
        Spacer()
        Text(contact.timeZone?.prettyPrintTime(currentTime.now) ?? "")
          .font(.subheadline)
      }
      Line(coordinate: contact.location, timezone: contact.timeZone)
        .frame(height: 80)
        .padding()
    }
    .padding()
  }
}

public struct ContactDetails<EditView>: View where EditView: View {
  @ObservedObject var contact: Contact
  var editView: () -> EditView

  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
  }

  public init(contact: Contact, @ViewBuilder editView: @escaping () -> EditView) {
    self.contact = contact
    self.editView = editView
  }

  #if os(iOS) || os(tvOS) || os(watchOS)
  public var body: some View {
    VStack {
      MapView(coordinate: contact.location)
      .edgesIgnoringSafeArea(.top)
      .frame(height: 300)

      Main(contact: contact)

      Spacer()
    }
    .navigationBarItems(trailing: editView())
  }
  #elseif os(macOS)
  public var body: some View {
    VStack {
      ZStack(alignment: .topTrailing) {
        MapView(coordinate: contact.location).edgesIgnoringSafeArea(.top)
        editView().padding()
      }
      .frame(height: 300)

      Main(contact: contact)

      Spacer()
    }
  }
  #endif
}

struct ContactDetails_Previews: PreviewProvider {
  static var previews: some View {
    let dummyContact = Contact()
    dummyContact.name = "Mathieu"
    dummyContact.latitude = 34.011286
    dummyContact.longitude = -116.166868
    return ContactDetails(contact: dummyContact) {
      Button(action: {
        print("edit")
      }) {
        Text("Edit")
      }
    }
  }
}

