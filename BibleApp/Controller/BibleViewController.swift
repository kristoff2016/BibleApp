//
//  ViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/6/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class BibleViewController: UIViewController {

    var bible: Bible!
    var selectedBookIndexPath: IndexPath? {
        didSet {
            bibleTableView.beginUpdates()
            if let index = selectedBookIndexPath {
                guard let cell = bibleTableView.cellForRow(at: index) as? ChapterTableViewCell else {return}
                cell.layoutIfNeeded()
            }
            bibleTableView.endUpdates()
        }
    }
    weak var bibleCoordinatorDelegate: BibleCoordinatorDelegate?
    
    let numberOfChapters = [50, 40, 27, 36, 34, 24, 21, 4, 31, 24, 22, 25, 29, 36, 10, 13, 10, 42, 150, 31, 12, 8, 66, 52, 5, 48, 12, 14, 3, 9, 1, 4, 7, 3, 3, 3, 2, 14, 4, 28, 16, 24, 21, 28, 16, 16, 13, 6, 6, 4, 4, 5, 3, 6, 4, 3, 1, 13, 5, 5, 3, 5, 1, 1, 1, 22]
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let topView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let bibleTableView: UITableView = {
       let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.showsVerticalScrollIndicator = false
        tv.rowHeight = UITableViewAutomaticDimension
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        return tv
    }()
    
    lazy var indexList: IndexTracker = {
        let oldIndexArray = ["Gn", "Ex", "Lv", "Nu", "Dt", "Jos", "Jdg", "Rut", "1Sa", "2Sa", "1Ki", "2Ki", "1Ch", "2Ch", "Ez", "Neh", "Es", "Job", "Ps", "Prv", "Ecc", "Sng", "Is", "Jer", "Lam", "Ez", "Dan", "Hos", "Jol", "Am", "Oba", "Jon", "Mic", "Nah", "Hab", "Zep", "Hag", "Zec", "Mal", "Mt", "Mk", "Lk", "Jn", "Ac", "Ro", "1Co", "2Co", "Gal", "Eph", "Php", "Col", "1Th", "2Th", "1Ti", "2Ti", "Ti", "Ph", "Heb", "Jm", "1Pt", "2Pt", "1Jn", "2Jn", "3Jn", "Jud", "Rv"]
        let il = IndexTracker(frame: .zero, indexList: oldIndexArray, height: view.frame.height - 200)
        il.translatesAutoresizingMaskIntoConstraints = false
        return il
    }()
    
    var dominantHand: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dominantHand = UserDefaults.standard.string(forKey: "DominantHand")
        if dominantHand == nil {
            UserDefaults.standard.set("Left", forKey: "DominantHand")
            dominantHand = "Left"
        }
        view.addSubview(topView)
        view.addSubview(containerView)
        containerView.addSubview(bibleTableView)
        containerView.addSubview(indexList)
        view.backgroundColor = .white
        layoutViews()
        bibleTableView.register(BibleTableViewCell.self, forCellReuseIdentifier: "cell")
        bibleTableView.register(ChapterTableViewCell.self, forCellReuseIdentifier: "chapterCell")
        bibleTableView.dataSource = self
        bibleTableView.delegate = self
        navigationItem.title = "Mt. Zion"
        indexList.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("rotated")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        let newDominant = UserDefaults.standard.string(forKey: "DominantHand")
        if newDominant != dominantHand {
            dominantHand = newDominant
            guard let indexListLeadingAnchor = indexListLeadingAnchor, let indexListTrailingAnchor = indexListTrailingAnchor, let containerViewLeadingAnchor = bibleTableViewLeadingAnchor, let containerViewTrailingAnchor = bibleTableViewTrailingAnchor else {return}
            NSLayoutConstraint.deactivate([indexListLeadingAnchor, indexListTrailingAnchor, containerViewLeadingAnchor, containerViewTrailingAnchor])
            setLayoutForDominantHand()
        }
    }
    
    var indexListLeadingAnchor: NSLayoutConstraint?
    var indexListTrailingAnchor: NSLayoutConstraint?
    var bibleTableViewLeadingAnchor: NSLayoutConstraint?
    var bibleTableViewTrailingAnchor: NSLayoutConstraint?
    
    func layoutViews() {
        topView.frame = CGRect(x: 0, y: -80, width: self.view.frame.width, height: 80)
        containerView.fillContainer(for: self.view)
        indexList.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        indexList.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        indexList.widthAnchor.constraint(equalToConstant: 25).isActive = true
        bibleTableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        bibleTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        setLayoutForDominantHand()
    }
    
    func setLayoutForDominantHand() {
        if dominantHand == "Left" {
            indexListLeadingAnchor = indexList.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
            indexListLeadingAnchor?.isActive = true
            indexListTrailingAnchor = indexList.trailingAnchor.constraint(equalTo: bibleTableView.leadingAnchor)
            indexListTrailingAnchor?.isActive = true
            bibleTableViewLeadingAnchor = bibleTableView.leadingAnchor.constraint(equalTo: indexList.trailingAnchor)
            bibleTableViewLeadingAnchor?.isActive = true
            bibleTableViewTrailingAnchor = bibleTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            bibleTableViewTrailingAnchor?.isActive = true
        } else {
            indexListTrailingAnchor = indexList.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            indexListTrailingAnchor?.isActive = true
            indexListLeadingAnchor = indexList.leadingAnchor.constraint(equalTo: bibleTableView.trailingAnchor)
            indexListLeadingAnchor?.isActive = true
            bibleTableViewTrailingAnchor = bibleTableView.trailingAnchor.constraint(equalTo: indexList.leadingAnchor)
            bibleTableViewTrailingAnchor?.isActive = true
            bibleTableViewLeadingAnchor = bibleTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
            bibleTableViewLeadingAnchor?.isActive = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BibleViewController: UITableViewDelegate, UITableViewDataSource, IndexListDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 66
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BibleTableViewCell
            cell.bibleBook = bible.returnBook(for: indexPath.section)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath) as! ChapterTableViewCell
            if selectedBookIndexPath == indexPath {
                cell.chapterCollectionView.isHidden = false
                cell.numberOfChapters = numberOfChapters[indexPath.section]
                cell.chapterCollectionView.reloadData()
            } else {
                cell.numberOfChapters = 0
                cell.chapterCollectionView.isHidden = true
            }
            cell.didSelectChapterCVDelegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == selectedBookIndexPath?.section && indexPath.row == 0 {
            selectedBookIndexPath = nil
            return
        }
        if !(indexPath.row == 1) {
            selectedBookIndexPath = IndexPath(row: 1, section: indexPath.section)
            guard let cell = bibleTableView.cellForRow(at: IndexPath(row: 1, section: indexPath.section)) as? ChapterTableViewCell else {return}
            cell.chapterCollectionView.isHidden = false
            cell.numberOfChapters = numberOfChapters[indexPath.section]
            cell.chapterCollectionView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedBookIndexPath == indexPath {
            return 30
        } else if indexPath.row == 1 {
            return 0
        } else {
            return 50
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if indexList.indexState == .scrollingTable {
            guard let firstCell = bibleTableView.visibleCells.first as? BibleTableViewCell else {return}
            guard let firstBook = firstCell.bibleBook else {return}
            if let index = bible.bookIndex(for: firstBook) {
                indexList.updatePositionOfBookMarker(index: index)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        let moreInfo = UITableViewRowAction(style: .default, title: "More Info") { [weak self] (action, indexPath) in
            self?.bibleCoordinatorDelegate?.openBibleWebsite(for: indexPath)
        }
        moreInfo.backgroundColor = MainColor.redOrange
        return [moreInfo]
    }
    
    func pressedIndex(at index: Int) {
        let numberOfIndexesInBible = 65
        if index < 0 || index > (numberOfIndexesInBible) {
            return
        }
        var generator: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()
        let indexPath = IndexPath(row: 0, section: index)
        UIView.animate(withDuration: 0.1) {
            self.bibleTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            if index < 51 {
                generator?.prepare()
                generator?.selectionChanged()
                generator = nil
            }
        }       
    }
}

extension BibleViewController: DidSelectChapterCVDelegate {
    func didSelectChapter(for chapter: Int) {
        guard let selectedIndex = selectedBookIndexPath else {return}
        let cell = bibleTableView.cellForRow(at: IndexPath(row: 0, section: selectedIndex.section)) as? BibleTableViewCell
        guard let book = cell?.bibleBook else {return}
        bibleCoordinatorDelegate?.openBibleChapter(book: book, chapter: chapter)
        selectedBookIndexPath = nil
    }
    
    
}

protocol BibleCoordinatorDelegate: class {
    func openBibleWebsite(for indexPath: IndexPath)
    func openBibleChapter(book: String, chapter: Int)
}

