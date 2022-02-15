//
//  AudioData.swift
//  CrossFader
//
//  Created by Дмитрий Фетюхин on 15.02.2022.
//

import Foundation
import UniformTypeIdentifiers

class AudioData {
    let types = UTType.types(tag: "mp3",
                             tagClass: UTTagClass.filenameExtension,
                             conformingTo: nil)
    var firstURL = URL(string: "")
    var secondURL = URL(string: "")
}
