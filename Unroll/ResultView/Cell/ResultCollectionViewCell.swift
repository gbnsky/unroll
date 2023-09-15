//
//  ResultCollectionViewCell.swift
//  Unroll
//
//  Created by Gabriel Garcia on 12/09/23.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let identifier: String = "ResultCollectionViewCell"
    
    // MARK: - Constants
    
    enum Constants {
        // url
        static let baseImageUrl: String = "https://image.tmdb.org/t/p/original/"
    }
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var movieStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: UIApplication.safeAreaEdgeInsets.bottom, right: 16)
        view.isLayoutMarginsRelativeArrangement = true
        view.axis = .vertical
        view.spacing = 16
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()
    
    private lazy var moviePoster: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "placeholder-poster")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.blackOne
        label.font = UIFont(name: Fonts.breeSerif, size: 24)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
    private lazy var movieReleaseDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.blackOne
        label.font = UIFont(name: Fonts.kanitRegular, size: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        view.isLayoutMarginsRelativeArrangement = true
        view.axis = .vertical
        view.spacing = 16
        view.alignment = .fill
        view.distribution = .fill
        view.backgroundColor = Colors.green
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.blackOne.cgColor
        return view
    }()
    
    private lazy var descriptionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.blackOne
        label.font = UIFont(name: Fonts.breeSerif, size: 24)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Description"
        return label
    }()
    
    private lazy var movieDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.blackOne
        label.font = UIFont(name: Fonts.kanitRegular, size: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - Private Properties
    
    private var movie: Movie?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Exposed Methods
    
    func setup(with movie: Movie) {
        self.movie = movie
        
        setupMoviePoster()
        setupMovieData()
    }
    
    // MARK: - Private Methods
    
    private func setupMoviePoster() {
        guard let movie = movie,
              let moviePosterPath = movie.posterPath,
              let posterPath = URL(string: "\(Constants.baseImageUrl)\(moviePosterPath)") else {
            return
        }
        
        moviePoster.load(url: posterPath) { imageSize in
            self.updateMoviePosterConstraints(with: imageSize)
        }
    }
    
    private func setupMovieData() {
        guard let movie = movie else {
            return
        }
        
        movieTitle.text = movie.title
        movieReleaseDate.text = getFormattedMovieReleaseDate(from: movie.releaseDate)
        movieDescription.text = movie.overview
    }
    
    private func getFormattedMovieReleaseDate(from releaseDate: String) -> String {
        let separator = String("-")
        let releaseDateArray = releaseDate.components(separatedBy: separator)
        return releaseDateArray.first ?? String()
    }
    
    private func updateMoviePosterConstraints(with imageSize: CGSize) {        
        NSLayoutConstraint.activate([
            moviePoster.heightAnchor.constraint(equalTo: moviePoster.widthAnchor, multiplier: getImageRatio(width: moviePoster.intrinsicContentSize.width, height: imageSize.height)),
        ])
    }
    
    private func getImageRatio(width: CGFloat, height: CGFloat) -> CGFloat {
        let ratio = height / width
        return ratio
    }
}

// MARK: - View Coding

extension ResultCollectionViewCell {
    
    private func loadView() {
        addSubviews()
        addConstraints()
        addCustomSpacings()
        addAdditionalConstraints()
    }
    
    private func addSubviews() {
        movieStackView.addArrangedSubview(movieTitle)
        movieStackView.addArrangedSubview(movieReleaseDate)
        movieStackView.addArrangedSubview(moviePoster)
        movieStackView.addArrangedSubview(descriptionStackView)
        
        descriptionStackView.addArrangedSubview(descriptionTitle)
        descriptionStackView.addArrangedSubview(movieDescription)
        
        scrollView.addSubview(movieStackView)
        addSubview(scrollView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
        
            // scroll view
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            
            // movie stack view
            
            movieStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            movieStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            movieStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            movieStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            movieStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func addCustomSpacings() {
        
        // movie stack view
        
        movieStackView.setCustomSpacing(.zero, after: movieTitle)
    }
    
    private func addAdditionalConstraints() {
        
        // movie stack view
        
        let stackViewHeight = movieStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        
        stackViewHeight.isActive = true
        stackViewHeight.priority = UILayoutPriority(50)
        
        // movie poster
        
        let moviePosterHeight = moviePoster.heightAnchor.constraint(equalTo: moviePoster.widthAnchor, multiplier: getImageRatio(width: moviePoster.intrinsicContentSize.width, height: moviePoster.intrinsicContentSize.height))
        
        moviePosterHeight.isActive = true
    }
}
