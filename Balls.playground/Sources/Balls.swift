import UIKit

public class Balls: UIView {
	private var colors: [UIColor]
	private var balls: [UIView] = []
	private var ballSize: CGSize = CGSize(width: 40, height: 40)
	private var animator: UIDynamicAnimator?
	private var snapBehavior: UISnapBehavior?
	private var collisionBehavior: UICollisionBehavior
	
	public init(colors: [UIColor]) {
		self.colors = colors
		collisionBehavior = UICollisionBehavior(items: [])
		collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
		super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
		backgroundColor = .gray
		animator = UIDynamicAnimator(referenceView: self)
		animator?.addBehavior(collisionBehavior)
		ballsView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func ballsView() {
		for (index, color) in colors.enumerated() {
			let ball = UIView(frame: CGRect.zero)
			ball.backgroundColor = color
			addSubview(ball)
			balls.append(ball)
			let origin = 40 * index + 100
			ball.frame = CGRect(x: origin, y: origin, width: Int(ballSize.width), height: Int(ballSize.height))
			ball.layer.cornerRadius = ball.bounds.width / 2
			collisionBehavior.addItem(ball)
		}
	}
	
	override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let touchLocation = touch.location(in: self)
			for ball in balls {
				if (ball.frame.contains(touchLocation)) {
					snapBehavior = UISnapBehavior(item: ball, snapTo: touchLocation)
					snapBehavior?.damping = 0.5
					animator?.addBehavior(snapBehavior!)
				}
			}
		}
	}
	
	override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let touchLocation = touch.location(in: self)
			if let behaviour = self.snapBehavior {
				behaviour.snapPoint = touchLocation
			}
		}
	}
	
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let behaviour = snapBehavior {
			animator?.removeBehavior(behaviour)
		}
		snapBehavior = nil
	}
	
}
