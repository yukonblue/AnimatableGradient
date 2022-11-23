//
//  AnimatableGradientModifier.swift
//  AnimatableGradient
//
//  Created by yukonblue on 2022-09-16.
//

import SwiftUI

/// https://www.appcoda.com/animate-gradient-swiftui/
///
public struct AnimatableGradientModifier: AnimatableModifier {

    let fromGradient: Gradient
    let toGradient: Gradient
    var progress: CGFloat = 0.0

    public var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    public func body(content: Content) -> some View {
        let gradientColors = zip(fromGradient.stops, toGradient.stops).map { (fromColor, toColor) in
            colorMixer(fromColor: UIColor(fromColor.color),
                       toColor: UIColor(toColor.color),
                       progress: progress)
        }

        return LinearGradient(gradient: Gradient(colors: gradientColors),
                              startPoint: .topLeading,
                              endPoint: .bottomTrailing)
    }

    private func colorMixer(fromColor: UIColor, toColor: UIColor, progress: CGFloat) -> Color {
        guard let fromColor = fromColor.cgColor.components else { return Color(fromColor) }
        guard let toColor = toColor.cgColor.components else { return Color(toColor) }

        let red = fromColor[0] + (toColor[0] - fromColor[0]) * progress
        let green = fromColor[1] + (toColor[1] - fromColor[1]) * progress
        let blue = fromColor[2] + (toColor[2] - fromColor[2]) * progress

        return Color(red: Double(red), green: Double(green), blue: Double(blue))
    }
}

public extension View {
    func animatableGradient(fromGradient: Gradient,
                            toGradient: Gradient,
                            progress: CGFloat
    ) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradient: fromGradient,
                                                 toGradient: toGradient,
                                                 progress: progress))
    }
}

struct AnimatableGradient_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, I am Content View")
            .animatableGradient(fromGradient: Gradient(colors: [.red, .yellow]),
                                toGradient: Gradient(colors: [.cyan, .blue]),
                                progress: 0.1)
    }
}
